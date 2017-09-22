
set serveroutput on;

CREATE OR REPLACE FUNCTION A1M_SUM_CUST_SALESYTD_FROM_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := PSTARTINGMARKS;
  Vsalesytd Number;
  
Begin 

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'SUM_CUST_SALESYTD';

  If Vcount <> 0 Then
    Dopl('SUM_CUST_SALESYTD NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE 
  
    -- CLEAR ALL CUSTOMERS
    DELETE FROM SALE;
    Delete From Customer;
    
    -- INSERT KNOWN CUSTOMER VALUES
    
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (221, 'Test Dude 1', 100, 'OK');

    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (222, 'Test Dude 2', 230, 'OK');    

    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (223, 'Test Dude 3', 75, 'OK'); 
                  
    BEGIN
      
      EXECUTE IMMEDIATE  'CALL ' || USER || '.Sum_Cust_Salesytd() INTO :Vsalesytd' USING OUT Vsalesytd;
      
      If Vsalesytd = 405 Then
        Vmarks := Vmarks + 2;
        Else
        Dopl('SUM_CUST_SALESYTD INCORRECT SUM RETURNED');
      End If;
      
    Exception
      When Others Then
        Dopl('SUM_CUST_SALESYTD GENERATED UNEXPECTED EXCEPTION - ' || Sqlerrm);
    End;                

   
    -- CHECK SUM_CUST_SALES_VIASQLDEV
    
    Select Count(*) Into Vcount From Sys.All_Objects
    Where Owner = User And  Object_Name = 'SUM_CUST_SALES_VIASQLDEV';
  
    If Vcount = 1 Then
      Vmarks := Vmarks + 1;
    Else
      Dopl('SUM_CUST_SALES_VIASQLDEV EITHER NOT ATTEMPTED OR NOT CORRECT');
    end if; 
  
    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/3 Marking points correct FOR SUM_CUST_SALESYTD AND SUM_CUST_SALES_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    
Exception
When Others Then
Dopl('ERROR IN SUM_CUST_SALESYTD  - ' || SQLERRM);
End;
/

