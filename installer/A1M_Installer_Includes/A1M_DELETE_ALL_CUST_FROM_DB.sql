set serveroutput on;



CREATE OR REPLACE FUNCTION A1M_DELETE_ALL_CUST_FROM_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

Vcount1 number;
Vcount2 Integer;
Vmarks Number := Pstartingmarks;
VCOUNT INTEGER;

BEGIN

  --EXECUTE IMMEDIATE ('BEGIN Add_Customer_To_Db(1, ''Test Dude 2''); END;');

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'DELETE_ALL_CUSTOMERS_FROM_DB';

  If VCOUNT <> 0 Then
    Dopl('DELETE_ALL_CUSTOMERS_FROM_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE

    -- CLEAR ANY EXISTSING CUSTOMERS FROM TABLE
    DELETE FROM SALE;
    Delete From Customer;

    -- insert a known number of customers.
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (1, 'Test Dude 1', 0, 'OK');
              
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (2, 'Test Dude 2', 0, 'OK');
              
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (3, 'Test Dude 3', 0, 'OK');

    -- call the function to be tested  

    EXECUTE IMMEDIATE  'CALL ' || USER || '.Delete_All_Customers_From_Db()  INTO :VCOUNT1' USING OUT VCOUNT1;

    --Vcount1 := Delete_All_Customers_From_Db;

    -- check number of rows remaining in DB
    Select Count(*) Into Vcount2 from customer;
  
    -- check that sll customers deleted
    If Vcount2 = 0 Then
      Vmarks := Vmarks + 1;
      Else
      Dopl('DELETE_ALL_CUSTOMERS_FROM_DB CUSTOMERS NOT CORRECTLY DELETED');
    End If;
    
    -- check that correct value is returned
    If Vcount1 = 3 Then
      Vmarks := Vmarks + 1;
      Else
      dopl('DELETE_ALL_CUSTOMERS_FROM_DB INCORRECT RETURN VALUE');
    End If;
    
    
    -- see if DELETE_ALL_CUSTOMERS_VIASQLDEV exists
    Select Count(*) Into Vcount1 From Sys.All_Objects
    Where Owner = User And Object_Name = 'DELETE_ALL_CUSTOMERS_VIASQLDEV';
  
    If Vcount1 = 0 Then
      Dopl('DELETE_ALL_CUSTOMERS_VIASQLDEV NOT CORRECT');
    Else   
      Vmarks := Vmarks + 1;
    End If;
    
    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/3 Marking points correct FOR DELETE_ALL_CUSTOMERS_FROM_DB AND DELETE_ALL_CUSTOMERS_VIASQLDEV');
    Return Vmarks;
  END IF;
    
Exception
  When Others Then
Dopl('code inspection required - ' || SQLERRM);
RETURN Vmarks;
End;
/



-- BLOCK FOR TESTING

--Begin
--Dopl(A1M_DELETE_ALL_CUST_FM_DB(10));
--END;