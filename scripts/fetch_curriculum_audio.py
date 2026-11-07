"""Fetch only selected normal recordings from the pinned sentence repository."""
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
import hashlib
import json
from pathlib import Path
import re
import sqlite3
import urllib.request

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--fetch',action='store_true',required=True)
    parser.parse_args()
    source=json.loads((ROOT/'content/sources.lock.json').read_bytes())['sentences']
    prefix=source['url'].rsplit('/',1)[0]+'/audio/'
    with sqlite3.connect(ROOT/'assets/content/curriculum.sqlite') as db:
        references=[json.loads(r[0]) for r in db.execute('SELECT payload_json FROM curriculum_audio WHERE local_available=0')]
    refs={r['sourceId']:r for r in references if r['speed']=='normal'}
    path=ROOT/'content/curriculum_audio.lock.json'
    locked=json.loads(path.read_bytes()) if path.exists() else {}
    def download(item):
        sid, ref=item
        if not re.fullmatch(r'hsk[1-6]-[0-9]{4}',sid) or ref['url']!=prefix+sid+'.mp3':
            raise ValueError('Audio reference outside pinned source')
        asset='assets/audio/'+sid+'.mp3'
        file=ROOT/asset
        if sid in locked and file.exists():
            data=file.read_bytes()
            if hashlib.sha256(data).hexdigest()==locked[sid]['sha256']: return sid,locked[sid]
        request=urllib.request.Request(ref['url'],headers={'User-Agent':'NiHaoRobot-content-import'})
        with urllib.request.urlopen(request,timeout=45) as response:
            if not response.url.startswith('https://raw.githubusercontent.com/no7z/hsk-sentences-audio/'):
                raise ValueError('Unexpected media redirect')
            data=response.read(2_000_001)
        if not 1<len(data)<=2_000_000 or not (data.startswith(b'ID3') or data[0]==255 and data[1]&224==224):
            raise ValueError('Invalid/oversized MP3')
        temporary=file.with_suffix('.mp3.part'); temporary.write_bytes(data); temporary.replace(file)
        return sid,dict(asset=asset,url=ref['url'],sha256=hashlib.sha256(data).hexdigest(),bytes=len(data),
            speed='normal',license='CC BY-SA 4.0',voice='zh-female-studio',synthetic=True)
    errors=[]
    with ThreadPoolExecutor(max_workers=8) as pool:
        pending={pool.submit(download,item):item[0] for item in refs.items()}
        for i,future in enumerate(as_completed(pending),1):
            try:
                sid,record=future.result(); locked[sid]=record
            except Exception as error: errors.append((pending[future],str(error)))
            if i%100==0 or i==len(pending):
                temporary=path.with_suffix('.json.part')
                temporary.write_text(json.dumps(locked,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');temporary.replace(path)
                print(f'{i}/{len(pending)} selected recordings checked; {len(errors)} failures',flush=True)
    if errors: raise RuntimeError(str(errors[:10]))
    print('Audio lock saved; run build_curriculum.py to link bundled files.',flush=True)


if __name__=='__main__': main()
