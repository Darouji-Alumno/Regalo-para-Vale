const fs=require('fs'),vm=require('vm'),cp=require('child_process');
const d=vm.runInNewContext(fs.readFileSync('story-data.js','utf8')+';STORY');
const total=d.total/1000,start=d.timeline.find(s=>s.type==='video').start/1000;
const filter=`[0:a][1:a]acrossfade=d=8:c1=qsin:c2=qsin,atrim=0:${total},volume=0.65,volume='if(between(t,${start-1},${start}),1-0.82*(t-${start-1}),if(between(t,${start},${start+13}),0.18,if(between(t,${start+13},${start+15}),0.18+0.82*(t-${start+13})/2,1)))':eval=frame,afade=t=in:d=3,afade=t=out:st=${total-10}:d=10[m];[2:a]afade=t=in:d=0.15,afade=t=out:st=12:d=0.757,adelay=${start*1000}:all=1[v];[m][v]amix=inputs=2:duration=first:normalize=0,alimiter=limit=0.95[out]`;
cp.execFileSync('ffmpeg',['-v','error','-y','-i','media/may-be.mp3','-i','media/river-flows-in-you.mp3','-i','media/recuerdo-2014.mp4','-filter_complex',filter,'-map','[out]','-c:a','libmp3lame','-b:a','192k','media/soundtrack.mp3'],{stdio:'inherit'});
