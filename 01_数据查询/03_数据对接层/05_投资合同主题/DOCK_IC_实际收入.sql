
--AM实际收入
SELECT AM_ORDER.C_ORDERID,
       AM_ORDER.C_PROJCODE,
       AM_ORDER.C_FUNDCODE,
       AM_ORDER.C_EXTYPE,
       AM_ORDER.D_DATE,
       AM_ORDER.D_DELIVERY,
       AM_ORDER.C_REMARK,
       AM_ORDER.F_DLVAMOUNT,
       am_order.c_status
  FROM AM_ORDER
 WHERE AM_ORDER.L_BUSIID = 22151
   and AM_ORDER.C_EXTYPE in ('101', '102', '105', '106')
   and AM_ORDER.C_PROJCODE is  null
   and AM_ORDER.D_DELIVERY <= to_date('20160930', 'yyyymmdd')
   and AM_ORDER.D_DELIVERY is not null
   --and am_order.c_projcode = 'AVICTC2014X0641' /*am_order.c_fundcode in ('ZH03Y8','ZH044Q')*/
 order by AM_ORDER.D_DELIVERY;