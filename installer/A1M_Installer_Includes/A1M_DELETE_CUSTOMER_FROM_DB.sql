
set serveroutput on;


CREATE OR REPLACE FUNCTION A1M_DELETE_CUSTOMER_FROM_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

Vcust Customer%Rowtype;
Vmarks Integer := PSTARTINGMARKS;
Vcount1 Integer;
Vcount2 Integer;
Vsubmark Integer := 0;
VCOUNT INTEGER;

BEGIN

  -- 3 MARKS ALLOCATED
  -- 1 FOR CORRECTLY DELETING CUSTOMER
  -- 1 FOR BOTH EXCEPTIONS CORRECT
  -- 1 FOR DELETE_CUSTOMER_VIASQLDEV

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'DELETE_CUSTOMER';

  If Vcount <> 0 Then
    Dopl('DELETE_CUSTOMER NOT ATEMPTED');
    Return Pstartingmarks;
  ELSE


  -- Clear TABLES AND ADD TEST DATA
  Delete From Sale;
  Delete From Customer;
  Delete From Product;
  
  Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (221, 'Test Dude 1', 100, 'OK');
                  
  Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (222, 'Test Dude 2', 250, 'OK');
                  
  Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1111, 'Test Product 1', 10, 50);
  
  Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1112, 'Test Product 2', 15, 150);
                  
  Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  VALUES(5, 221, 1111, 10, 12, SYSDATE);
                  
  Begin
    -- CHECK FOR CORRECT DLETE

    EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Delete_Customer(222);END;');

    Select Count(*) Into Vcount1 From Customer Where Custid = 222;
    SELECT COUNT(*) INTO VCOUNT2 FROM CUSTOMER;
    
    If Vcount1 = 0 And Vcount2 = 1 Then
      VmarkS := VmarkS + 1;
    Else
      Dopl('DELETE_CUSTOMER - CUSTOMER NOT DELETED CORRECTLY');
    END IF;
    
  ExcePtion
   When Others Then
       Dopl('DELETE_CUSTOMER - DELETING CUSTOMER GENERATED UNEXPECTED EXCEPTION');
  END;
  
  Begin
  
   -- CHECK FOR CUSTOMER ID NOT FOUND
   EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Delete_Customer(333);END;');
   
   
   -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
   Dopl('DELETE_CUSTOMER - CUSTOMER ID NOT FOUND EXCEPTION NOT RAISED');
  
  Exception
    When Others Then
      If Sqlcode = -20201 
         And Upper(Sqlerrm) Like '%CUSTOMER%'
         And Upper(Sqlerrm) Like '%ID%'
         And Upper(Sqlerrm) Like '%NOT%'
         And Upper(Sqlerrm) Like '%FOUND%' Then
         
          Vsubmark := Vsubmark + 1;

        Else
          Dopl('DELETE_CUSTOMER - CUSTOMER ID NOT FOUND EXCEPTION NOT CORRECT');
      End If;
    
  END;
  
  Begin
  
   -- CHECK FOR CUSTOMER HAS CHILD ROWS IN SALE TABLE
    EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Delete_Customer(221);END;');
   
   -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
   Dopl('DELETE_CUSTOMER - CUSTOMER HAS CHILD ROWS EXCEPTION NOT RAISED');
  
  Exception
    When Others Then
      If Sqlcode = -20202 
         And Upper(Sqlerrm) Like '%CUSTOMER%'
         And Upper(Sqlerrm) Like '%CANNOT%'
         And Upper(Sqlerrm) Like '%DELETED%'
         And Upper(Sqlerrm) Like '%SALES%'
         And Upper(Sqlerrm) Like '%EXIST%' Then
         
          Vsubmark := Vsubmark + 1;
          
        Else
          Dopl('DELETE_CUSTOMER - CUSTOMER HAS CHILD ROWS EXCEPTION NOT CORRECT');
      End If;
    
  END;
  
  If Vsubmark = 2 Then
    Vmarks := Vmarks + 1;
  Else
     Dopl('DELETE_CUSTOMER - ONE OR MORE EXCEPTION INCORRECT');
  End If;
  
  -- CHECK DELETE_CUSTOMER_VIASQLDEV
  
  Select Count(*) Into Vcount1 From Sys.All_Objects
  Where Owner = User And Object_Name = 'DELETE_CUSTOMER_VIASQLDEV';
  
  If Vcount1 = 1 Then
    Vmarks := Vmarks + 1;

  Else
    Dopl('DELETE_CUSTOMER_VIASQLDEV - EITHER NOT ATTEMPTED OR NOT CORRECT');
    
  End If;

    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/3 Marking points correct FOR DELETE_CUSTOMER DELETE_CUSTOMER_VIASQLDEV');
    RETURN VMARKS;  
  END IF;

EXCEPTION

When Others Then
    Dopl('DELETE_CUSTOMER GENERATED UNEXPECTED EXCEPTION - ' || SQLERRM);

End;
/






