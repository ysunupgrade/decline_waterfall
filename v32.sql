------------------------------------------------------------
------------------------------------------------------------
-- decline_qc_v32
------------------------------------------------------------
------------------------------------------------------------

if [ADVERSE_ACTIONS] in ('account_blocked','CheckPhoneForVOIPBlockedRule',
'email_blocked','ip_blocked','multifactorknockoutrule2','name_dob_blocked','phone_blocked','traveler_name_dob_blocked') then '0.PRE UW FRAUD'
elseif [ADVERSE_ACTIONS] in ('APPLICANT_NOT_FOUND_AT_BUREAU') then '0.1 APPLICANT NOT FOUND AT BUREAU'
elseif ISNULL([FICO8_TU]) or [FICO8_TU] < 550 then '1 FICO < 550'
elseif [G059S] > 12 then '2 G059S>12'
elseif [S063S] > 2500 then '3 S063S>2500'
elseif [S114S] > 9 then '4 S114S>9'
elseif ISNULL([AT20S]) or [AT20S] < 3 then '5 AT20S<3'
elseif ISNULL([G106S]) or [G106S] < 9 then '6 G106S<9'
elseif [S207S] >= 0 and [S207S] < 12 then '8 S207S<12'
elseif [S207A] >= 0 and [S207A] < 12 then '8 S207A<12'
elseif [G094S] > 1 then '9 G094S>1'
elseif [REALTIMEPBOSUMSSN] >= [max_amount_v32] then '11 PROGRAM BALANCE'
elseif [RTMMAXDAYSPASTDUE] >= 7 then '13 PAST DUE 7 DAYS'
elseif [RTMNUMCHARGEDOFF] > 0 then '14 CHARGED OFF'

elseif [fprm1] >= [fprm1_decline_threshold_v32] then '16 FRPM1'

elseif not ISNULL([FTR1]) and [FTR1] >= [ftr1_decline_threshold_v32] then '18 FRT1'

elseif [STATE] = 'WA' and [APR_V17] >= 0.25 then '19 OTHER:STATE RESTRICTION'
elseif [STATE] = 'MD' and [APR_V17] >= 0.24 then '19 OTHER:STATE RESTRICTION'
elseif [STATE] = 'MA' and ([ORDER_AMOUNT] <= 6000 and [APR_V17] >= 0.12) then '19 OTHER:STATE RESTRICTION'
elseif [STATE] = 'NJ' and [APR_V17] >= 0.30 then '19 OTHER:STATE RESTRICTION'
elseif [STATE] = 'CO' and [APR_V17] >= 0.21 then '19 OTHER:STATE RESTRICTION'
elseif [STATE] = 'NY' and [APR_V17] >= 0.25 then '19 OTHER:STATE RESTRICTION'
elseif [STATE] = 'CT' and ([ORDER_AMOUNT] >= 5000 and [APR_V17] >= 0.25) then '19 OTHER:STATE RESTRICTION'
elseif [STATE] = 'WI' and ([ORDER_AMOUNT] <= 2000 and [TERM1] > 24) then '19 OTHER:STATE RESTRICTION'
elseif [STATE] in ('DC','IA','WV') then '19 OTHER:STATE RESTRICTION'

elseif [APR_V17] > 0.3599 then '20 OTHER:APR RESTRICTION'

elseif [ORDER_AMOUNT] - ([max_amount_v32] - [REALTIMEPBOSUMSSN]) > 0.5 * [ORDER_AMOUNT] then '21 OTHER: MAX CAP RESTRICTION'

elseif [POST_UW_FRAUD] = True then '22 POST UW FRAUD'

// elseif [ORDER_AMOUNT] < 48 or [ADVERSE_ACTIONS] in ('TRIP_ITINERARY') then '23 TRIP_ITINERARY'

else null
end
  
------------------------------------------------------------
------------------------------------------------------------
-- max_amount_v32
------------------------------------------------------------
------------------------------------------------------------

  
if [UPCODE] in ('UP-79934337-50', 'UP-79934337-55', 'UP-79934337-59', 'UP-79934337-1') then
    (if [FICO8_TU] >= 780 and [fprm1] < 0.04 then 500000
    elseif [FICO8_TU] >= 780 and [fprm1] >= 0.04 then 250000
    elseif [FICO8_TU] >= 750 then 60000
    elseif [FICO8_TU] >= 700 then 50000
    elseif [FICO8_TU] >= 660 and [fprm1] < 0.06 then 20000
    elseif [FICO8_TU] >= 660 and [fprm1] >= 0.06 then 12000
    elseif [FICO8_TU] >= 600 and [fprm1] < 0.07 then 10000
    elseif [FICO8_TU] >= 600 and [fprm1] >= 0.07 then 5000
    elseif [FICO8_TU] < 600 and [fprm1] < 0.08 then 3000
    elseif [FICO8_TU] < 600 and [fprm1] >= 0.08 then 1500
    else 0
    end)

elseif [UPCODE] = 'UP-32535293-54' then
    (if [FICO8_TU] > 720 then 120000
    else 0
    end)

elseif [UPCODE] in ('UP-20956569-3', 'UP-20956569-1', 'UP-20956569-99', 'UP-20956569-98', 'UP-20956569-6', 'UP-20956569-7') then
    (if [FICO8_TU] >= 720 and [fprm1] < 0.04 then 25000
    elseif [FICO8_TU] >= 720 and [fprm1] >= 0.04 then 15000
    elseif [FICO8_TU] >= 660 and [fprm1] < 0.06 then 20000
    elseif [FICO8_TU] >= 660 and [fprm1] >= 0.06 then 12000
    elseif [FICO8_TU] >= 600 and [fprm1] < 0.07 then 10000
    elseif [FICO8_TU] >= 600 and [fprm1] >= 0.07 then 5000
    elseif [FICO8_TU] < 600 and [fprm1] < 0.08 and [ADVANCE_PURCHASE_DAYS] >= 120 then 4000
    elseif [FICO8_TU] < 600 and [fprm1] < 0.08 and [ADVANCE_PURCHASE_DAYS] < 120 then 3000
    elseif [FICO8_TU] < 600 and [fprm1] >= 0.08 and [ADVANCE_PURCHASE_DAYS] >= 120 then 4000
    elseif [FICO8_TU] < 600 and [fprm1] >= 0.08 and [ADVANCE_PURCHASE_DAYS] < 120 then 1500
    else 0
    end)

elseif [UPCODE] = 'UP-43928860-60' then
    (if [FICO8_TU] >= 780 then 100000
    elseif [FICO8_TU] >= 700 then 75000
    elseif [FICO8_TU] >= 660 then 50000
    elseif [FICO8_TU] >= 620 then 15000
    elseif [FICO8_TU] < 620 then 10000
    else 0
    end)

else
    (if [FICO8_TU] >= 780 and [fprm1] >= 0.02 then 15000
    elseif [FICO8_TU] >= 780 and [fprm1] < 0.02 then 50000
    elseif [FICO8_TU] >= 720 and [fprm1] < 0.04 then 30000
    elseif [FICO8_TU] >= 720 and [fprm1] >= 0.04 then 15000
    elseif [FICO8_TU] >= 660 and [fprm1] < 0.06 then 20000
    elseif [FICO8_TU] >= 660 and [fprm1] >= 0.06 then 12000
    elseif [FICO8_TU] >= 600 and [fprm1] < 0.07 then 10000
    elseif [FICO8_TU] >= 600 and [fprm1] >= 0.07 then 5000
    elseif [FICO8_TU] < 600 and [fprm1] < 0.08 then 3000
    elseif [FICO8_TU] < 600 and [fprm1] >= 0.08 then 1500
    else 0
    end)

end

------------------------------------------------------------
------------------------------------------------------------
-- fprm1_decline_threshold_v32
------------------------------------------------------------
------------------------------------------------------------

if ([ADVANCE_PURCHASE_DAYS] >= 120 
and [UPCODE] in ('UP-20956569-3', 'UP-20956569-1', 'UP-20956569-99', 'UP-20956569-98', 'UP-20956569-6', 'UP-20956569-7'))
or ([UPCODE] in ('UP-43928860-1','UP-43928860-2') and [FICO8_TU] >= 620 and [LOYALTY_FLAG] = 'True') 
then [fprm1_decline_threshold_tb_b_v17]

elseif [UPCODE] in ('UP-79934337-50', 'UP-79934337-55', 'UP-79934337-59', 'UP-79934337-1', 
                     'UP-79934337-51', 'UP-79934337-54', 'UP-79934337-52', 'UP-79934337-56', 
                     'UP-79934337-57', 'UP-79934337-53', 'UP-79934337-61', 'UP-79934337-58', 
                     'UP-79934337-62', 'UP-79934337-63', 'UP-79934337-60') 
and [FICO8_TU] < 700 then [fprm1_decline_threshold_tb_f_v24]

elseif [UPCODE] in ('UP-17367120-1', 'UP-17367120-50', 'UP-17367120-3') 
then [fprm1_decline_threshold_tb_c_v17]

elseif [UPCODE] = 'UP-43928860-60' then [fprm1_decline_threshold_tb_g_v32]

elseif [known_user] = 1 or ([FICO8_TU] >= 620 and [LOYALTY_FLAG] = 'True') then [fprm1_decline_threshold_tb_a_v17]

else
    (if [merchant_lookup] = 'CARNIVAL' or [THIRDPARTYLOAN] = 0 then [fprm1_decline_threshold_tb_d_v17]
    elseif ([merchant_lookup] <> 'CARNIVAL' or ISNULL([merchant_lookup])) and [THIRDPARTYLOAN] = 1 
then [fprm1_decline_threshold_tb_e_v17]
    else null
    end)
end

------------------------------------------------------------
------------------------------------------------------------
-- fprm1_decline_threshold_tb_b_v17
------------------------------------------------------------
------------------------------------------------------------

IF [FICO8_TU] >= 780 THEN 0.28
ELSEIF [FICO8_TU] >= 740 AND [FICO8_TU] < 780 THEN 0.28
ELSEIF [FICO8_TU] >= 700 AND [FICO8_TU] < 740 THEN 0.28
ELSEIF [FICO8_TU] >= 660 AND [FICO8_TU] < 700 THEN 0.31
ELSEIF [FICO8_TU] >= 620 AND [FICO8_TU] < 660 THEN 0.31
ELSEIF [FICO8_TU] >= 580 AND [FICO8_TU] < 620 THEN 0.34
ELSEIF [FICO8_TU] >= 540 AND [FICO8_TU] < 580 THEN 0.34
ELSEIF [FICO8_TU] < 540 THEN 0
ELSE NULL
END

------------------------------------------------------------
------------------------------------------------------------
-- fprm1_decline_threshold_tb_f_v24
------------------------------------------------------------
------------------------------------------------------------

IF [FICO8_TU] >= 780 THEN 1
ELSEIF [FICO8_TU] >= 740 AND [FICO8_TU] < 780 THEN 1
ELSEIF [FICO8_TU] >= 700 AND [FICO8_TU] < 740 THEN 1
ELSEIF [FICO8_TU] >= 660 AND [FICO8_TU] < 700 THEN 0.10
ELSEIF [FICO8_TU] >= 620 AND [FICO8_TU] < 660 THEN 0.10
ELSEIF [FICO8_TU] >= 580 AND [FICO8_TU] < 620 THEN 0.10
ELSEIF [FICO8_TU] >= 540 AND [FICO8_TU] < 580 THEN 0.10
ELSEIF [FICO8_TU] < 540 THEN 0
ELSE NULL
END

------------------------------------------------------------
------------------------------------------------------------
-- fprm1_decline_threshold_tb_c_v17
------------------------------------------------------------
------------------------------------------------------------

IF [FICO8_TU] >= 780 THEN 0.10
ELSEIF [FICO8_TU] >= 740 AND [FICO8_TU] < 780 THEN 0.10
ELSEIF [FICO8_TU] >= 700 AND [FICO8_TU] < 740 THEN 0.10
ELSEIF [FICO8_TU] >= 660 AND [FICO8_TU] < 700 THEN 0.13
ELSEIF [FICO8_TU] >= 620 AND [FICO8_TU] < 660 THEN 0.13
ELSEIF [FICO8_TU] >= 580 AND [FICO8_TU] < 620 THEN 0.01
ELSEIF [FICO8_TU] >= 540 AND [FICO8_TU] < 580 THEN 0.01
ELSEIF [FICO8_TU] < 540 THEN 0
ELSE NULL
END

------------------------------------------------------------
------------------------------------------------------------
-- fprm1_decline_threshold_tb_g_v32
------------------------------------------------------------
------------------------------------------------------------

IF [FICO8_TU] >= 700 THEN 0.4
ELSEIF [FICO8_TU] >= 620 THEN 0.5
ELSEIF [FICO8_TU] >= 540 THEN 0.6
ELSEIF [FICO8_TU] < 540 THEN 0
ELSE NULL
END

------------------------------------------------------------
------------------------------------------------------------
-- fprm1_decline_threshold_tb_a_v17
------------------------------------------------------------
------------------------------------------------------------
  
IF [FICO8_TU] >= 780 THEN 0.26
ELSEIF [FICO8_TU] >= 740 AND [FICO8_TU] < 780 THEN 0.26
ELSEIF [FICO8_TU] >= 700 AND [FICO8_TU] < 740 THEN 0.26
ELSEIF [FICO8_TU] >= 660 AND [FICO8_TU] < 700 THEN 0.29
ELSEIF [FICO8_TU] >= 620 AND [FICO8_TU] < 660 THEN 0.29
ELSEIF [FICO8_TU] >= 580 AND [FICO8_TU] < 620 THEN 0.32
ELSEIF [FICO8_TU] >= 540 AND [FICO8_TU] < 580 THEN 0.32
ELSEIF [FICO8_TU] < 540 THEN 0
ELSE NULL
END

------------------------------------------------------------
------------------------------------------------------------
-- fprm1_decline_threshold_tb_d_v17
------------------------------------------------------------
------------------------------------------------------------
if [MERCHANT_GRADE_V17] = 5 then
    (if [FICO8_TU] >= 780 then 0.07
    elseif [FICO8_TU] >= 740 then 0.07
    elseif [FICO8_TU] >= 700 then 0.07
    elseif [FICO8_TU] >= 660 then 0.12
    elseif [FICO8_TU] >= 620 then 0.12
    elseif [FICO8_TU] >= 580 then 0.17
    elseif [FICO8_TU] >= 540 then 0.17
    elseif [FICO8_TU] < 540 then 0
    else null
    end)

elseif [MERCHANT_GRADE_V17] = 4 then
    (if [FICO8_TU] >= 780 then 0.12
    elseif [FICO8_TU] >= 740 then 0.12
    elseif [FICO8_TU] >= 700 then 0.12
    elseif [FICO8_TU] >= 660 then 0.16
    elseif [FICO8_TU] >= 620 then 0.16
    elseif [FICO8_TU] >= 580 then 0.21
    elseif [FICO8_TU] >= 540 then 0.21
    elseif [FICO8_TU] < 540 then 0
    else null
    end)

elseif [MERCHANT_GRADE_V17] = 3 then
    (if [FICO8_TU] >= 780 then 0.18
    elseif [FICO8_TU] >= 740 then 0.18
    elseif [FICO8_TU] >= 700 then 0.18
    elseif [FICO8_TU] >= 660 then 0.21
    elseif [FICO8_TU] >= 620 then 0.21
    elseif [FICO8_TU] >= 580 then 0.24
    elseif [FICO8_TU] >= 540 then 0.24
    elseif [FICO8_TU] < 540 then 0
    else null
    end)

elseif [MERCHANT_GRADE_V17] = 2 then
    (if [FICO8_TU] >= 780 then 0.20
    elseif [FICO8_TU] >= 740 then 0.20
    elseif [FICO8_TU] >= 700 then 0.20
    elseif [FICO8_TU] >= 660 then 0.23
    elseif [FICO8_TU] >= 620 then 0.23
    elseif [FICO8_TU] >= 580 then 0.26
    elseif [FICO8_TU] >= 540 then 0.26
    elseif [FICO8_TU] < 540 then 0
    else null
    end)

elseif [MERCHANT_GRADE_V17] = 1 then
    (if [FICO8_TU] >= 780 then 0.26
    elseif [FICO8_TU] >= 740 then 0.26
    elseif [FICO8_TU] >= 700 then 0.26
    elseif [FICO8_TU] >= 660 then 0.29
    elseif [FICO8_TU] >= 620 then 0.29
    elseif [FICO8_TU] >= 580 then 0.32
    elseif [FICO8_TU] >= 540 then 0.32
    elseif [FICO8_TU] < 540 then 0
    else null
    end)
else
    null
end

------------------------------------------------------------
------------------------------------------------------------
-- fprm1_decline_threshold_tb_e_v17
------------------------------------------------------------
------------------------------------------------------------

if [MERCHANT_GRADE_V17] = 5 then
    (if [FICO8_TU] >= 780 then 0.07
    elseif [FICO8_TU] >= 740 then 0.07
    elseif [FICO8_TU] >= 700 then 0.07
    elseif [FICO8_TU] >= 660 then 0.12
    elseif [FICO8_TU] >= 620 then 0.12
    elseif [FICO8_TU] >= 580 then 0.17
    elseif [FICO8_TU] >= 540 then 0.17
    elseif [FICO8_TU] < 540 then 0
    else null
    end)

elseif [MERCHANT_GRADE_V17] = 4 then
    (if [FICO8_TU] >= 780 then 0.09
    elseif [FICO8_TU] >= 740 then 0.09
    elseif [FICO8_TU] >= 700 then 0.09
    elseif [FICO8_TU] >= 660 then 0.14
    elseif [FICO8_TU] >= 620 then 0.14
    elseif [FICO8_TU] >= 580 then 0.19
    elseif [FICO8_TU] >= 540 then 0.19
    elseif [FICO8_TU] < 540 then 0
    else null
    end)

elseif [MERCHANT_GRADE_V17] = 3 then
    (if [FICO8_TU] >= 780 then 0.11
    elseif [FICO8_TU] >= 740 then 0.11
    elseif [FICO8_TU] >= 700 then 0.11
    elseif [FICO8_TU] >= 660 then 0.16
    elseif [FICO8_TU] >= 620 then 0.16
    elseif [FICO8_TU] >= 580 then 0.21
    elseif [FICO8_TU] >= 540 then 0.21
    elseif [FICO8_TU] < 540 then 0
    else null
    end)

elseif [MERCHANT_GRADE_V17] = 2 then
    (if [FICO8_TU] >= 780 then 0.13
    elseif [FICO8_TU] >= 740 then 0.13
    elseif [FICO8_TU] >= 700 then 0.13
    elseif [FICO8_TU] >= 660 then 0.18
    elseif [FICO8_TU] >= 620 then 0.18
    elseif [FICO8_TU] >= 580 then 0.23
    elseif [FICO8_TU] >= 540 then 0.23
    elseif [FICO8_TU] < 540 then 0
    else null
    end)

elseif [MERCHANT_GRADE_V17] = 1 then
    (if [FICO8_TU] >= 780 then 0.15
    elseif [FICO8_TU] >= 740 then 0.15
    elseif [FICO8_TU] >= 700 then 0.15
    elseif [FICO8_TU] >= 660 then 0.20
    elseif [FICO8_TU] >= 620 then 0.20
    elseif [FICO8_TU] >= 580 then 0.25
    elseif [FICO8_TU] >= 540 then 0.25
    elseif [FICO8_TU] < 540 then 0
    else null
    end)

else
    null
end


------------------------------------------------------------
------------------------------------------------------------
-- ftr1_decline_threshold_v32
------------------------------------------------------------
------------------------------------------------------------

if [UPCODE] in ('UP-17367120-1', 'UP-17367120-50', 'UP-17367120-3') then
    (if [fprm1] < 0.05 then 1.01
    elseif [fprm1] >= 0.05 and [fprm1] < 0.10 then 1.01
    elseif [fprm1] >= 0.10 and [fprm1] < 0.15 then 0.20
    elseif [fprm1] >= 0.15 and [fprm1] < 0.20 then 0.15
    elseif [fprm1] >= 0.20 and [fprm1] < 0.25 then 0.10
    elseif [fprm1] >= 0.25 then 0
    else null
    end)

elseif [UPCODE] = 'UP-43928860-60' then 1.01

elseif [MERCHANT_GRADE_V17] in (1,2,3,4,5) then
    (if [fprm1] < 0.05 then 1.01
    elseif [fprm1] >= 0.05 and [fprm1] < 0.10 then 1.01
    elseif [fprm1] >= 0.10 and [fprm1] < 0.15 then 0.20
    elseif [fprm1] >= 0.15 and [fprm1] < 0.20 then 0.15
    elseif [fprm1] >= 0.20 and [fprm1] < 0.25 then 0.10
    elseif [fprm1] >= 0.25 then 0
    else null
    end)

else null
end







































