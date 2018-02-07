--会计科目表
select t.c_id         as C_SUBID, --科目ID
       t.c_number     as C_SUBCODE, --科目代码
       t.c_name       as C_SUBNAME, --科目名称
       t1.c_number    as L_CLASS, --科目分类
       0              as C_FUNDID, --账套ID
       t.f_dc         as L_BALDIR, --余额方向
       t.f_level      as L_LEVEL, --科目级次
       t.f_isleaf     as L_LEAF, --是否明细
       t.c_currencyid as C_CYKIND, --币种代码
       t.c_parentid   as C_FSUBCODE --父级科目
  from TS_EA_AccountView t, TS_EA_AccountType t1
 where t.c_accounttypeid = t1.c_id;

--凭证分录表
select t.c_id            as C_JOURID, --分录ID
       t.c_billid        as C_VOUCHERID, --凭证ID
       0                 as C_FUNDID, --账套ID
       t1.d_bizdate      as D_BUSI, --业务日期
       t1.c_description  as C_DIGEST, --凭证摘要
       t.f_seq           as L_ROWID, --分录号
       t2.c_number       as C_SUBCODE, --科目代码
       t2.c_name         as C_SUBNAME, --科目名称
       t.F_ENTRYDC       as L_BALDIR, --余额方向
       0                 as F_DEBIT, --本币借方
       0                 as F_CREDIT, --本币贷方
       t4.c_number       as C_CYKIND, --币种代码
       null              as F_EXCH, --汇率
       null              as F_FOREIGN, --外币金额
       t1.f_bizstatus    as L_STATE, --凭证状态
       t3.f_periodyear   as L_YEAR, --会计年度
       t3.f_periodnumber as L_MONTH, --会计月份
       null              as C_COMBID --组合ID
  from TS_EA_VoucherEnt  t,
       TS_EA_Voucher     t1,
       ts_ea_accountview t2,
       TS_EA_Period      t3,
       TS_EA_Currency    t4
 where t.c_billid = t1.c_id
   and t.c_accountid = t2.c_id
   and t1.c_periodid = t3.c_id
   and t.c_currencyid = t4.c_id;

--辅项分类表
select t.c_id     as C_CLASSID, --分类ID
       t.c_number as C_CLASSNO, --分类编号
       t.c_name   as C_CLASSNAME, --分类名称
       null       as C_FCLASSID, --父类ID
       null       as C_REMARK --备注
  from TS_EA_GeneralAsstActTypeGrp t;

--部门信息表
select t.c_id       as C_DEPTID, --部门ID
       t.c_number   as C_DEPTCODE, --部门编号
       t.c_name     as C_DEPTNAME, --部门名称
       t.c_parentid as C_PARENTID, --上级部门ID
       t.F_ISSTART  as C_ISVOID --是否失效
  from TS_EA_Admin t;

--员工信息
select t.fid          as C_STAFFID, --员工ID
       t1.c_id        as C_DEPTID, --所属部门ID
       t.fnumber      as C_STAFFCODE, --员工号
       t.fname_l2     as C_STAFFNAME, --员工名称
       null           as C_IDTYPE, --证件类型
       t.fidcardno    as C_IDCARD, --证件号码
       null           as C_CTQCNO, --从业资格证号
       null           as C_POSTING, --职务
       null           as C_ISSENIOR, --是否高管
       null           as C_NOSTAFF, --是否无编制
       t.fstate       as C_STATUS, --在职状态
       t.fcell        as C_MOBILE, --手机
       t.fofficephone as C_TEL, --电话
       t.femail       as C_EMAIL, --邮箱
       null           as C_MSGMODE, --消息方式
       null           as C_REMARK --备注
  from TS_EA_Person t, TS_EA_admin t1
 where t.fHRORGUNITID = t1.c_id;

--产品信息

--银行账户
select t.c_id                as C_ACCID, --账户ID
       t.c_name              as C_ACCNAME, --帐户名称
       t.c_bankaccountnumber as C_ACCNO, --帐户账号
       t1.c_name             as C_ORGNAME, --开户机构名称
       t.c_bank              as C_HEADBANKNO, --开户总行编号
       t.f_isclosed          as C_ISVOID --是否失效
  from TS_EA_AccountBanks t, TS_EA_Company t1
 where t.c_companyid = t1.c_id;
