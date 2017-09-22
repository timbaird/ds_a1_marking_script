
set serveroutput on;


CREATE OR REPLACE FUNCTION A1M_GET_CUST_STRING_FROM_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := PSTARTINGMARKS;
  Vcust Customer%Rowtype;
  vprod product%rowtype;
  Vstring Varchar(1000);
  --Vsubmarks Integer :=0;
  

Begin 

 SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'GET_CUST_STRING_FROM_DB';

  If VCOUNT <> 0 Then
    Dopl('GET_CUST_STRING_FROM_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE
  
  
    -- CHECK FOR CORRECT FUNCTION WITH GOOD DATA
    begin
        -- CLEAR THE CUSTOMER TABLE
        DELETE FROM SALE;
        Delete From Customer;
      
        -- ADD KNOWN CUSTOMER
        Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                    Values (355, 'Test Dude 1', 666, 'SUSPEND');
    
        EXECUTE IMMEDIATE  'CALL ' || USER || '.GET_CUST_STRING_FROM_DB(355) INTO :vstring' USING OUT vstring;

        VSTRING := UPPER(VSTRING);
    
        -- CHECK THE OUTPUT STRING CONTAINS THE CORRECT COMPONENTS.
        If Vstring Like '%CUSTID%' And
          Vstring Like '%355%' And
          Vstring Like '%NAME%' And
          Vstring Like '%TEST DUDE 1%' And
          Vstring Like '%STATUS%' And
          Vstring Like '%SUSPEND%' And
          ( Vstring Like '%SALESYTD%' OR Vstring Like '%SALES_YTD%') And
          Vstring Like '%666%' Then
         
          Vmarks := Vmarks + 1;
        Else
          dopl('GET_CUST_STRING_FROM_DB CORRECT CUST STRING NOT RETREIVED');
        End If;

    
      Exception
        When Others Then
          Dopl('ERROR WITH GET_CUST_STRING_FROM_DB : ' || SQLERRM );
      End;
  
      -- CHECK FOR CUSTOMER NOT FOUNF EXCEPTION
  
    
    Begin
      -- ensure there are no customes in DB
      delete from sale;
      Delete From Customer;
      
      -- call the function

        EXECUTE IMMEDIATE  'CALL ' || USER || '.GET_CUST_STRING_FROM_DB(500) INTO :vstring' USING OUT vstring;
      
      -- if exception raised this line will not execute
      Dopl('GET_CUST_STRING_FROM_DB DID NOT RAISE EXPECTED EXCEPTION');
    Exception
      When Others Then
        If Sqlcode = -20021 
            And Upper(Sqlerrm) Like '%CUSTOMER%'
            And Upper(Sqlerrm) Like '%ID%'
            And Upper(Sqlerrm) Like '%NOT%'
            And Upper(Sqlerrm) Like '%FOUND%' Then
            
          Vmarks := Vmarks + 1;
        Else
          Dopl('GET_CUST_STRING_FROM_DB DID NOT RAISE EXPECTED EXCEPTION');
        End If;
    End;
      
  
  
    -- CHECK IF GET_CUST_STRING_VIASQLDEV
    Select Count(*) Into Vcount From Sys.All_Objects
    Where Owner = User And Object_Name = 'GET_CUST_STRING_VIASQLDEV';
  
    If Vcount = 1 Then
       Vmarks := Vmarks + 1;
    Else
    dopl('GET_CUST_STRING_VIASQLDEV EITHER NOT ATTEMPTED OR INCORRECT');
    end if;
  
    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/3 Marking points correct FOR GET_CUST_STRING_FROM_DB AND GET_CUST_STRING_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    
Exception
When Others Then
Dopl('ERROR IN GET_CUST_STRING_FROM_DB.SQL code - ' || SQLERRM);
End;
/


-- BLOCK FOR TESTING

--Begin
--Dopl(A1M_GET_CUST_STRING_FROM_DB(10));
--END;




