-- 1. Select each MSISDN.
select msisdn from ipdr02;
-- 2. Select Specific start and end datetime domain/app wise.
select starttime,endtime,domain from ipdr02
group by domain;
-- 4. For each VoIP APP, identify each single call as like the graphical table at the bottom of this 
-- document 
-- - Need to calculate first ST (start time), ET (End Time) for each FDR.
-- - then to calculate ET*(ET-10 min) for each FDR to exclude idle time (10 min) of each 
-- FDR
-- - If ET-10 min < ST then keep the original ET.
-- 5. Calculate Total volume of each call of each domain=(Sum of DL volume of all FDR + Sum of 
-- UL volume of all FDR) in Kb. Value of UL and DL in CDR is in Byte.
select starttime,endtime,msisdn,ulvolume,dlvolume,domain,((ulvolume+dlvolume)/1024) as kb from ipdr02;

-- 6. Calculate Total time of each call of each VoIP App= [each call Highest ET* among respected 
-- FDR's(minute) - each call lowest ST among respected FDR's (minute)] in sec.
SELECT TIMESTAMPDIFF(SECOND, starttime, endtime) as 'total_Volume' from ipdr
group by msisdn, domain;

-- 7. Calculate bit rate(kbps) of each call of each VoIP App= (Total volume of each call of each 
-- VOIP App/Total time of each call of each VOIP App)
select(((ulvolume+dlvolume)/1024)/36000)/(TIMESTAMPDIFF(SECOND, starttime, endtime)) as kbps from ipdr;

-- 8.Identification of Audio or video call and its count, - For each VoIP APP, if bit rate(kbps) of each call of each VoIP App <10kbps, discard the call record.Assuming <=200 Kbps is audio call,>200 kbps is video call


create view  VW_kbps as 
(
select(((ulvolume+dlvolume)/1024)/36000)/(TIMESTAMPDIFF(SECOND, starttime, endtime)) as kbps,Msisdn,domain,
(TIMESTAMPDIFF(SECOND, starttime, endtime)) as durations_in_sec,count(kb) as fdr_count
from ipdr
group by domain,msisdn);

SELECT kbps, Msisdn,domain,durations_in_sec,fdr_count,
(CASE
    WHEN kbps > 200 THEN "isVideo"
    WHEN Quantity <= 200 THEN "isaudio"
    ELSE "It is not ok"
END) as 'Vido/Audio'
FROM ipdr;