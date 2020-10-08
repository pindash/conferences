waittime:100;fulfilltime:100;
addRequest:{if[(spawnChance>rand 1.0);if[max_active>=exec sum status in `pending`progress from requests;`requests upsert `id`driverId`waittime`fulfilltime`status!(ID+:1;0N;waittime;fulfilltime;`pending)]]};
distributetaxis:{ freedrivers:exec driverId from taxis where not inuse;
 update driverId:freedrivers til count driverId from `requests where status=`pending;
 update status:`progress from `requests where status=`pending, not null driverId};
cleanUpRequests:{ update fulfilltime:fulfilltime-1 from (update waittime:waittime-1 from `requests where status=`pending) where status=`progress;
 update status:`cancelled from `requests where waittime<=0;
 update status:`finished from `requests where fulfilltime<=0;
 update inuse:driverId in (exec driverId from `requests where status=`progress) from `taxis};
run:{[runtime;spawnChance;max_active;ntaxis]
 `ID`taxis`spawnChance`max_active`requests set' (-1; ([driverId:til ntaxis];inuse:ntaxis#0b);spawnChance;max_active;([]id:7h$();driverId:7h$();waittime:6h$();fulfilltime:6h$();status:11h$()));
  `LOG set ([]age:();occupied:();free:();inprog:();waiting:();cancelled:();finished:());
  progress:(cleanUpRequests distributetaxis addRequest ::);
  logger:{[p;step] p[]; cnts:(enlist[`dummy]!enlist[0]),(count each group requests[`status]); used:first sum taxis;
   `LOG upsert ([]age:enlist step;occupied:used;free:ntaxis-used;inprog:0^cnts`progress;waiting:0^cnts`pending;cancelled:0^cnts`cancelled;finished:0^cnts`finished)}[progress];
  logger each til runtime}
/use
run[1440;0.2;2000;200]
