SET SERVEROUTPUT ON;

Create Or Replace Function A1M_Add_Customer_To_Db(Pstartingmarks Number) Return Number AUTHID CURRENT_USER As


  Vcount Integer;
  Vcust Customer%Rowtype;
  Vmarks Integer := Pstartingmarks;

Begin
	
-- PREVENT STUDENTS DOPL FROM UPSETTING FORMATTING
  --DBMS_OUTPUT.DISABLE;

SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'ADD_CUST_TO_DB'; -- altered

  If Vcount <> 0 Then
  	--DBMS_OUTPUT.ENABLE;
    Dopl('ADD_CUST_TO_DB NOT ATEMPTED');
    --DBMS_OUTPUT.DISABLE;
    RETURN Pstartingmarks;
  ELSE

    -- CLEAR ANY EXISTSING CUSTOMERS FROM TABLE
    DELETE FROM SALE;
    Delete From Customer;
    COMMIT;
  
    -- ADD A TEST CASE;
    EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Cust_To_Db(1, ''Test Dude 1''); END;');

    -- RECOVER THE ADDED CUSTOMER
    -- IF CUST NOT EXISTS THEN NOT CORRECTLY ADDED, SEE DATA_NOT_FOUND_EXCEPTION
    Select * Into VCust 
    From Customer
    Where Custid = 1;
  
    -- CHECK CUSTOMER INSERTED CORRECTLY
    If Vcust.Custname = 'Test Dude 1'
       And Upper(Vcust.Status) = 'OK' 
       And Vcust.Sales_Ytd = 0 Then
       
      -- CUSTOMER INSERTED CORRECTLY
      Vmarks := Vmarks + 1;
      Else
	  --DBMS_OUTPUT.ENABLE; 
      Dopl('ADD_CUST_TO_DB -  CUSTOMER INSERTION HAS ERROR');
	  --DBMS_OUTPUT.DISABLE;
    End If;
    
   
    -- CHECK FOR DUP_VAL_ON_INDEX EXCEPTION
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Cust_To_Db(1, ''Test Dude 2''); END;');
	  --DBMS_OUTPUT.ENABLE;
	  Dopl('ADD_CUST_TO_DB -  DUPLICATE CUSTOMER ID EXCEPTION NOT THROWN');
	  --DBMS_OUTPUT.DISABLE;
    Exception
      When Others Then
        If Sqlcode = -20010 -- altered 
           And Upper(Sqlerrm) Like '%DUPLICATE%'
           And Upper(Sqlerrm) Like '%CUSTOMER%'
           And Upper(Sqlerrm) Like '%ID%' Then
           
          Vmarks := Vmarks + 1;

         Else
		  --DBMS_OUTPUT.ENABLE;
          Dopl('ADD_CUST_TO_DB -  DUPLICATE CUSTOMER ID EXCEPTION NOT CORRECT');
		  --DBMS_OUTPUT.DISABLE;
        End If;
    End;
    
    -- CHECK FOR OUT OF RANGE CUSTOMER ID
    Begin 
    EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Cust_To_Db(500, ''Test Dude 3''); END;');
	  --DBMS_OUTPUT.ENABLE;
	  Dopl('ADD_CUST_TO_DB - CORRECT CUSTOMER ID OUT OF RANGE EXCEPTION NOT THROWN');
	  --DBMS_OUTPUT.DISABLE;
    Exception
      When Others Then
        If Sqlcode = -20002 
           And Upper(Sqlerrm) Like '%CUSTOMER%'
           And Upper(Sqlerrm) Like '%ID%'
           And Upper(Sqlerrm) Like '%OUT%'
           And Upper(Sqlerrm) Like '%OF%'
           And Upper(Sqlerrm) Like '%RANGE%' Then
           
          Vmarks := Vmarks + 1;
          Else
		  	--DBMS_OUTPUT.ENABLE;
          	Dopl('ADD_CUST_TO_DB - CORRECT CUSTOMER ID OUT OF RANGE EXCEPTION NOT CORRECT');
		  	--DBMS_OUTPUT.DISABLE;
        End If;
    End;

    -- CHECK THAT ADD_CUST_VIASQLDEV HAS BEEN ATTEMPTED
    Select Count(*) Into Vcount From Sys.All_Objects
    Where Owner = User And Object_Name = 'ADD_CUSTOMER_VIASQLDEV';
  
    If Vcount = 0 Then
	  --DBMS_OUTPUT.ENABLE;
      Dopl('ADD_CUSTOMER_VIASQLDEV EITHER NOT ATTEMPTED OR NOT CORRECT');
	  --DBMS_OUTPUT.DISABLE;
    Else
      Vmarks := Vmarks + 1;
    END IF;

    -- output the marks  
	--DBMS_OUTPUT.ENABLE;  
    Dopl( Vmarks - PSTARTINGMARKS || '/4 Marking points correct FOR ADD_CUST_TO_DB ADD_CUSTOMER_VIASQLDEV');
	--DBMS_OUTPUT.DISABLE;
    RETURN VMARKS;  
  END IF;

Exception
When No_Data_Found Then
  --DBMS_OUTPUT.ENABLE;
  Dopl('ADD_CUST_TO_DB - CUSTOMER NOT INSERTED');
  RETURN VMARKS;
  --DBMS_OUTPUT.DISABLE;
When Others Then
  --DBMS_OUTPUT.ENABLE;
  Dopl('ERROR MARKING ADD_CUST_TO_DB - ' || SQLERRM);
  RETURN VMARKS;
  --DBMS_OUTPUT.DISABLE;
End;
/


-- BLOCK FOR TESTING

--Begin
--Dopl(A1M_Add_Cust_To_Db(10));
--END;
