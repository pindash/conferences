genRequests:{[w;ft;sc;n] n:sum  sc>n?1.0;([]driverId:0N;waittime:2+n?w;fulfilltime:1+n?ft;status:`pending)};
run:{[waittime;fulfilltime;runtime;spawnChance;maxactive;ntaxis] {[maxactive;maxtime;drivers;requests] if[maxtime<=first requests[`t];:requests];tc:til count ::;
 fdrivers:drivers except exec driverId from requests where status=`progress;
 step:$[count fdrivers;1;min exec fulfilltime-t-startride from requests where status=`progress];requests:update t:t+step from requests;
 requests:delete from requests where age<=t, status=`pending, (maxactive-sum[((<=/)requests`age`t)&(`progress=requests`status)])<tc i;
 requests:update driverId:fdrivers tc i, status:`progress`pending null fdrivers tc i, startride:?[null fdrivers tc i;0N;t] from requests where age<=t,status=`pending;
 requests:update status:`cancelled, done:t from requests where t>=age+waittime, status=`pending;
 update status:`finished, done:t from requests where t>=fulfilltime+startride, status=`progress}[maxactive;runtime;asc til ntaxis;] over 
  update id:i,startride:0N, t:-1, done:0N from ungroup ([]age:til runtime)!flip each genRequests[waittime;fulfilltime;spawnChance] each runtime#maxactive};
stats:{[r] raze {[r;j]select age:enlist j, inprog:sum j within (0W^startride;done), waiting:sum j within (age;startride-1),cancelled:sum (status=`cancelled)&(j>=done),finished:sum (status=`finished)&(j>=done) from r}[r] each til max r[`t]}
/stats  run[100;100;1000;0.2;2000;500]
