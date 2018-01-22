select t.workflow_name,
       t.start_time,
       t.end_time,
       (t.end_time - t.start_time) * 24 * 60 * 60
  from opb_wflow_run t
 where t.workflow_name in ('wf_ods2dock_msxt', 'wf_dock2edw_ms') and to_char(t.start_time,'hh24') = 12
 and to_char(t.start_time,'yyyymm') = '201711'
 order by t.workflow_name,t.start_time desc;
