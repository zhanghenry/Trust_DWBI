update tde_individual t set t.c_address = null;
update tde_individual t set t.c_postcode = null;
update tde_individual t set t.c_mobile_no = null;
update tde_individual t set t.c_contact_no = null;
update tde_individual t set t.c_email = null;

update tde_individual set c_indiv_name = rpad(substr(c_indiv_name,1,1), lengthb(c_indiv_name)-1,'*') where rpad(substr(c_indiv_name,1,1), lengthb(c_indiv_name)-1,'*') is not null;
update tde_individual set c_name_abbr = rpad(substr(c_name_abbr,1,1), lengthb(c_name_abbr)-1,'*') where rpad(substr(c_name_abbr,1,1), lengthb(c_name_abbr)-1,'*') is not null;
update tde_organization set c_organ_name = rpad(substr(c_organ_name,1,1), lengthb(c_organ_name)-1,'*') where rpad(substr(c_organ_name,1,1), lengthb(c_organ_name)-1,'*') is not null;


update dim_pb_individual set c_indiv_name = rpad(substr(c_indiv_name,1,1), lengthb(c_indiv_name)-1,'*') where rpad(substr(c_indiv_name,1,1), lengthb(c_indiv_name)-1,'*') is not null;

update dim_pb_individual set c_name_abbr = rpad(substr(c_name_abbr,1,1), lengthb(c_name_abbr)-1,'*') where rpad(substr(c_name_abbr,1,1), lengthb(c_name_abbr)-1,'*') is not null;

update dim_pb_organization set c_organ_name = rpad(substr(c_organ_name,1,1), lengthb(c_organ_name)-1,'*') where rpad(substr(c_organ_name,1,1), lengthb(c_organ_name)-1,'*') is not null;

select * from dim_ic_counterparty;

update dim_ic_counterparty set c_party_name = rpad(substr(c_party_name,1,1), lengthb(c_party_name)-1,'*') where rpad(substr(c_party_name,1,1), lengthb(c_party_name)-1,'*') is not null;

update dim_ic_counterparty set c_name_abbr = rpad(substr(c_name_abbr,1,1), lengthb(c_name_abbr)-1,'*') where rpad(substr(c_name_abbr,1,1), lengthb(c_name_abbr)-1,'*') is not null;

update dim_ic_contract set c_real_party = rpad(substr(c_real_party,1,1), lengthb(c_real_party)-1,'*') where rpad(substr(c_real_party,1,1), lengthb(c_real_party)-1,'*') is not null;

select * from dim_ic_contract;
