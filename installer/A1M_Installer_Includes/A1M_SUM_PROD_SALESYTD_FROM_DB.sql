
set serveroutput on;

CREATE OR REPLACE FUNCTION A1M_SUM_PROD_SALESYTD_FROM_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := PSTARTINGMARKS;
  Vsalesytd Number;
  
Begin 

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'SUM_PROD_SALESYTD_FROM_DB';

  If Vcount <> 0 Then
    Dopl('SUM_PROD_SALESYTD_FROM_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE 
  
    -- CLEAR ALL PRODUCTS
    DELETE FROM SALE;
    Delete From PRODUCT;
    
    -- INSERT KNOWN PRODUCT VALUES
    
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1111, 'Test Product 1', 10, 100); 
                  
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1112, 'Test Product 1', 10, 120); 
                  
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1113, 'Test Product 1', 10, 302); 
                  
    BEGIN
    
    EXECUTE IMMEDIATE  'CALL ' || USER || '.Sum_Prod_Salesytd_From_Db() INTO :Vsalesytd' USING OUT Vsalesytd;
      
      If Vsalesytd = 522 Then
        Vmarks := Vmarks + 2;
        Else
        Dopl('SUM_PROD_SALESYTD_FROM_DB INCORRECT SUM RETURNED');
      End If;
      
    Exception
      When Others Then
        Dopl('SUM_PROD_SALESYTD_FROM_DB GENERATED UNEXPECTED EXCEPTION - ' || Sqlerrm);
    End;                

   
    -- CHECK SUM_PROD_SALES_VIASQLDEV
    
    Select Count(*) Into Vcount From Sys.All_Objects
    Where Owner = User And  Object_Name = 'SUM_PROD_SALES_VIASQLDEV';
  
    If Vcount = 1 Then
      Vmarks := Vmarks + 1;
    Else
      Dopl('SUM_PROD_SALES_VIASQLDEV EITHER NOT ATTEMPTED OR NOT CORRECT');
    end if; 
  
    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/3 Marking points correct FOR SUM_PROD_SALESYTD_FROM_DB AND SUM_PROD_SALES_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    
Exception
When Others Then
Dopl('ERROR IN SUM_PROD_SALESYTD_FROM_DB  - ' || SQLERRM);
End;
/

