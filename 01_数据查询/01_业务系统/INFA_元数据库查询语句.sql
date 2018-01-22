--查看会话的运行日志
select c.task_name         as 任务名称,
       b.start_time        as 开始时间,
       b.end_time          as 结束时间,
       a.mapping_name      as 会话名称,
       a.src_success_rows  as 源抽取成功记录数,
       a.src_failed_rows   as 源抽取失败记录数,
       a.targ_success_rows as 目标加载成功记录数,
       a.targ_failed_rows  as 目标加载失败记录数,
       a.first_error_msg   as 错误信息
  from opb_sess_task_log a, opb_wflow_run b, opb_task c
 where a.workflow_run_id = b.workflow_run_id
   and b.workflow_id = c.task_id
   and c.task_type = 71
   and a.mapping_name in( 'm_ts_hsfa_vouchers_ful','m_tdc_fa_vouchers_ful')
   order by b.start_time desc,a.mapping_name;