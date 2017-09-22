
-- PASS 'RESET' AS A PARAMETER TO RESET YOUR DATABASE BETWEEN STUDENTS.
-- PASS NO PARAMETER IF YOU WITH TO GRADE THE CURRENTLY LOADED ASSIGNMENT.

CREATE OR REPLACE PROCEDURE A1M_MARK_DBSYS_ASS1(pReset VARCHAR2 default 'DO_NOT_RESET') AUTHID CURRENT_USER as

vPassRequirement Number(3,2) := 0.8;
Vmarks Integer := 0;
vtotal integer;

vResultPart1 Boolean := FALSE;
vResultPart2 Boolean := FALSE;
vResultPart3 Boolean := FALSE;
vResultPart4 Boolean := FALSE;
vResultPart5 Boolean := FALSE;
vResultPart6 Boolean := FALSE;

vOutput VARCHAR2(50);

Begin

  A1m_Premark_Check;

  IF upper(pReset) <> 'RESET' then

    -- MARK THE ASSIGNMENT

    Dopl(' ');
    Dopl('#########################');
    Dopl(' ');
    Dopl('PART 1');
    Dopl(' ');

    begin
    Vmarks := A1m_Add_Customer_To_Db(Vmarks);
    Exception
    When Others Then
    Dopl('error marking Add_Customer_To_Db');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    begin
    Vmarks := A1m_Delete_All_Cust_From_Db(Vmarks);
    Exception
    When Others Then
    Dopl('error marking Delete_All_Cust_From_Db');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    begin
    Vmarks := A1m_Add_Product_To_Db(Vmarks);
    Exception
    When Others Then
    Dopl('error marking Add_Product_To_Db');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    begin
    Vmarks := A1m_Delete_All_Prod_From_Db(Vmarks);
    Exception
    When Others Then
    Dopl('error marking Delete_All_Prod_From_Db');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    begin
    Vmarks := A1m_GET_CUST_STRING_FROM_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking GET_CUST_STRING_FROM_DB');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    begin
    Vmarks := A1m_UPD_CUST_SALESYTD_IN_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking UPD_CUST_SALESYTD_IN_DB');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    begin
    Vmarks := A1m_GET_PROD_STRING_FROM_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking GET_PROD_STRING_FROM_DB');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    begin
    Vmarks := A1m_UPD_PROD_SALESYTD_IN_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking UPD_PROD_SALESYTD_IN_DB');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    begin
    Vmarks := A1m_UPD_CUST_STATUS_IN_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking UPD_CUST_STATUS_IN_DB');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    begin
    Vmarks := A1m_ADD_SIMPLE_SALE_TO_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking ADD_SIMPLE_SALE_TO_DB');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    begin
    Vmarks := A1M_SUM_CUST_SALESYTD_FROM_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking SUM_CUST_SALESYTD_FROM_DB');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    begin 
    Vmarks := A1m_Sum_PROD_Salesytd_From_Db(Vmarks);
    Exception
    When Others Then
    Dopl('error marking Sum_PROD_Salesytd_From_Db');
    Dopl(Sqlerrm);
    end;

    Dopl(' ');
    Dopl(' ');
    
    if (vPassRequirement * 40) < vmarks then
      DOPL('PART 1 RESULT: PASS');
      vResultPart1 := TRUE;
    ELSE
      DOPL('PART 1 RESULT: FAIL');
    end if;
  
    Vtotal := Vmarks;
    VMARKS := 0;
  
    Dopl(' ');
    Dopl('#########################');
    Dopl(' ');
    Dopl('PART 2');
  
    Dopl(' ');
    begin
    Vmarks := A1m_GET_ALLCUST_FROM_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking GET_ALLCUST_FROM_DB');
    Dopl(Sqlerrm);
    end;
    Dopl(' ');
    begin   
    Vmarks := A1M_GET_ALLPROD_FROM_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking GET_ALLPROD_FROM_DB');
    Dopl(Sqlerrm);
    end;
     
  
  
  
    Dopl(' ');
    if (vPassRequirement * 15) < vmarks then
      DOPL('PART 2 RESULT: PASS');
      vResultPart2 := TRUE;
    ELSE
      DOPL('PART 2 RESULT: FAIL');
    end if;
  
    Vtotal := VTOTAL + Vmarks;
    VMARKS := 0;


    Dopl(' ');
    Dopl('#########################');
    Dopl(' ');
    Dopl('PART 3');
  
    Dopl(' ');
    begin
    Vmarks := A1m_ADD_LOCATION_TO_DB(Vmarks);
        Exception
    When Others Then
    Dopl('error marking ADD_LOCATION_TO_DB');
    Dopl(Sqlerrm);
    end;
    Dopl(' ');
  
    if (vPassRequirement * 5) < vmarks then
      DOPL('PART 3 RESULT: PASS');
      vResultPart3 := TRUE;
    ELSE
      DOPL('PART 3 RESULT: FAIL');
    end if;
  
    Vtotal := Vtotal + Vmarks;
    VMARKS := 0;

    Dopl(' ');
    Dopl('#########################');
    Dopl(' ');
    Dopl('PART 4');
  
    Dopl(' ');
    begin
    Vmarks := A1M_ADD_COMPLEX_SALE_TO_DB(Vmarks);
        Exception
    When Others Then
    Dopl('error marking ADD_COMPLEX_SALE_TO_DB');
    Dopl(Sqlerrm);
    end;
    Dopl(' ');
    begin 
    Vmarks := A1m_Get_Allsales_From_Db(Vmarks);
        Exception
    When Others Then
    Dopl('error marking Get_Allsales_From_Db');
    Dopl(Sqlerrm);
    end;
    Dopl(' ');
    begin  
    Vmarks := A1M_COUNT_PROD_SALES_FROM_DB(Vmarks);
        Exception
    When Others Then
    Dopl('error marking COUNT_PROD_SALES_FROM_DB');
    Dopl(Sqlerrm);
    end;

  
    Dopl(' ');
    if (vPassRequirement * 10) < vmarks then
      DOPL('PART 4 RESULT: PASS');
      vResultPart4 := TRUE;
    ELSE
      DOPL('PART 4 RESULT: FAIL');
    end if;
  
  
    Vtotal := Vtotal + Vmarks;
    VMARKS := 0;

    Dopl(' ');
    Dopl('#########################');
    Dopl(' ');
    Dopl('PART 5');
  
    Dopl(' ');
    begin
    Vmarks := A1M_DELETE_SALE_FROM_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking DELETE_SALE_FROM_DB');
    Dopl(Sqlerrm);
    end;
    Dopl(' ');
    begin 
    Vmarks := A1M_DELETE_ALL_SALES_FROM_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking DELETE_ALL_SALES_FROM_DB');
    Dopl(Sqlerrm);
    end;

  
  
    Dopl(' ');
    if (vPassRequirement * 10) < vmarks then
      DOPL('PART 5 RESULT: PASS');
      vResultPart5 := TRUE;
    ELSE
      DOPL('PART 5 RESULT: FAIL');
    end if;
  
    Vtotal := Vtotal + Vmarks;
    VMARKS := 0;


    Dopl(' ');
    Dopl('#########################');
    Dopl(' ');
    Dopl('PART 6');
  
    Dopl(' ');
    begin
    Vmarks := A1m_DELETE_CUSTOMER_FROM_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking DELETE_CUSTOMER_FROM_DB');
    Dopl(Sqlerrm);
    end;
    Dopl(' ');
    begin  
  
    Vmarks := A1m_DELETE_PROD_FROM_DB(Vmarks);
    Exception
    When Others Then
    Dopl('error marking DELETE_PROD_FROM_DB');
    Dopl(Sqlerrm);
    end;

    
    Dopl(' ');
    
    if (vPassRequirement * 5) < vmarks then
      DOPL('PART 6 RESULT: PASS');
      vResultPart6 := TRUE;
    ELSE
      DOPL('PART 6 RESULT: FAIL');
    end if;
  
    Vtotal := Vtotal + Vmarks;
    VMARKS := 0;

  else

    drop_if_exists('all', true, true);

  End If;
  
  
  DOPL('');
  dopl('##########################');
  dopl('##########################');
  dopl('FINAL RESULT SUMMARY');
  dopl('##########################');
  DOPL('');
  if vResultPart1 and vResultPart2 and vresultPart3 then
    DOPL('PASS LEVEL TASKS : SATISFACTORY');
  ELSE
    DOPL('PASS LEVEL TASKS : NOT YET SATISFACTORY');
  END IF;
  
   if vResultPart3 and vResultPart4 and vresultPart5 then
    DOPL('CREDIT LEVEL TASKS : SATISFACTORY');
  ELSE
    DOPL('CREDIT LEVEL TASKS : NOT YET SATISFACTORY');
  END IF; 
  


Exception
  When Others Then
  Raise;
End;
/

SHOW ERRORS;

