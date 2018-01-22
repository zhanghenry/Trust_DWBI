--流程类型
select t.*, SYS_CONNECT_BY_PATH(t.type_name, '|') || '|' C_PATH
  from JBPM4_EXT_PROCESS_TYPE t
 start with t.parent_id = 0
connect by prior t.dbid_ = t.parent_id;

--流程信息
select t2.type_name,t1.* from JBPM4_EXT_PRO t1,JBPM4_EXT_PROCESS_TYPE t2 where t1.type_id = t2.dbid_ and t1.type_id = '434372';

--流程包含的实例，用version区别
select * from JBPM4_EXT_TASKDEF_DETAIL t where t.process_key_ = 'projectEvaluation2' and t.version_no_ = 106;

--流程调度，暂不清楚与实例的关系
select * from JBPM4_DEPLOYMENT t where t.process_key_ = 'projectEvaluation2' --t.dbid_ = '410231';

select * from JBPM4_EXECUTION t where t.procdefid_ like 'projectEvaluation2%';

--实例信息
select * from JBPM4_HIST_PROCINST t where t.procdefid_ = 'projectEvaluation2-37' order by t.start_;

--实例发起及最新状态，跟jbpm4_ext_hist_task作用重叠，可不用
select * from JBPM4_EXT_START t where t.process_instance_ = 'projectEvaluation2.411951';
--实例下面的任务执行情况
select t1.*
  from jbpm4_hist_task t, jbpm4_ext_hist_task t1
 where t.procinst_ = '411951'
   and t.dbid_ = t1.dbid_
 order by to_char(t.create_, 'yyyymmdd');
 
select * from jbpm4_hist_task t where t.procinst_ = '411951';

--里面的task id 无法关联
select * from JBPM4_PARTICIPATION t where t.task_ = '411961';
select * from JBPM4_VARIABLE;

--看不出作用
select * from JBPM4_EXT_DETAILS;--5

--这里的process_id不清楚是什么，跟储存在JBPM4_EXT_PRO表内的数据不一致
select * from JBPM4_EXT_PT_TRAN t where t.type_id = '60011';

select * from JBPM4_EXT_DELEGATE_DETAIL t where t.process_key_ = 'projectEvaluation2';
select * from JBPM4_EXT_DELEGATE t where t.dbid_ in (select t1.delegate_id_ from JBPM4_EXT_DELEGATE_DETAIL t1 where t1.process_key_ = 'projectEvaluation2');--指派


--select * from JBPM4_DEMO_CUSTOMER;
--select * from JBPM4_DEPLOYPROP;
--select * from JBPM4_EXT_CONFIG;
--select * from JBPM4_EXT_FORM_RESREG;
--select * from JBPM4_EXT_FORM_RESSTATUS;
--select * from JBPM4_EXT_LOG;
--select * from JBPM4_EXT_MWTEMPLATE;
--select * from JBPM4_EXT_NODE_FIELDS;
--select * from JBPM4_EXT_PROCINST;
--select * from JBPM4_EXT_PRO_VER;
--select * from JBPM4_EXT_TASK_CTL;
--select * from JBPM4_EXT_TRACE;
--select * from JBPM4_EXT_VERSION_CONTEXTFIELD;
--select * from JBPM4_EXT_VER_DEP;
--select * from JBPM4_FORMTEXT_DEMO;
--select * from JBPM4_FORMTEXT_LEAVE;
--select * from JBPM4_HIST_DETAIL;
--select * from JBPM4_HS_TASK;
--select * from JBPM4_ID_GROUP;
--select * from JBPM4_ID_MEMBERSHIP;
--select * from JBPM4_ID_USER;
--select * from JBPM4_JOB;
--select * from JBPM4_LOB;
--select * from JBPM4_PROPERTY;
--select * from JBPM4_SWIMLANE;

select * from JBPM4_EXT_PRO;--流程
select * from JBPM4_EXT_PROCESS_TYPE;--流程类型
select * from JBPM4_EXT_PT_TRAN;--非常重要


select * from JBPM4_HIST_PROCINST;--流程下面的实例
select * from JBPM4_HIST_TASK t ;--实例下面的任务，包含历史
select * from JBPM4_TASK t;

select * from JBPM4_EXT_HIST_TASK;--实例下面的任务
select * from JBPM4_HIST_VAR;--实例包含的变量

select * from JBPM4_EXT_START;--实例发起

select * from JBPM4_EXT_TASKDEF_DETAIL;--非常重要

select * from JBPM4_PARTICIPATION;--重要
select * from JBPM4_VARIABLE;--重要

select * from JBPM4_EXT_NOTICE;--通知
select * from JBPM4_EXT_NOTICE_RECIVER;--通知接收者
select * from JBPM4_EXT_NOTICE_STATUS;--通知状态

select * from JBPM4_DEPLOYMENT;--调度
select * from JBPM4_EXECUTION;
select * from JBPM4_EXT_COMBOBOX_;
select * from JBPM4_EXT_DELEGATE;--指派
select * from JBPM4_EXT_DELEGATE_DETAIL;--指派明细

select * from JBPM4_EXT_EXP;
select * from JBPM4_EXT_FORMCLASS;
select * from JBPM4_EXT_FORMREG;

select * from JBPM4_EXT_TEMPLATE_DATA;
select * from JBPM4_EXT_VER;
select * from JBPM4_EXT_VER_OPR;--
select * from JBPM4_HIST_ACTINST;--活动明细

select * from JBPM4_EXT_PROC_EDITOR;
select * from JBPM4_EXT_SERVICEREG;
select * from JBPM4_EXT_SERVICE_ERROR;
select * from JBPM4_EXT_SERVICE_FORM;
select * from JBPM4_EXT_SERVICE_PARA_IN;
select * from JBPM4_EXT_SERVICE_PARA_OUT;
