
set serveroutput on;


CREATE OR REPLACE FUNCTION A1M_DELETE_ALL_SALES_FROM_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := PSTARTINGMARKS;
  Vsaleid Sale.Saleid%Type;
  Vcust Customer%Rowtype;
  vprod product%rowtype;
  
Begin 

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'DELETE_ALL_SALES_FROM_DB';

  If Vcount <> 0 Then
    Dopl('DELETE_ALL_SALES_FROM_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE

    -- 4 MARKS ALLOCATED
    
    -- 1 FOR DELETEING ALL SALES
    -- 1 FOR UPDATING CUSTOMER SALES YTD 
    -- 1 FOR UPDATING PRODUCT SALES YTD 
    -- 1 FOR DELETE_ALL_SALES_VIASQLDEV


    -- CLEAR ALL TABLES
    Delete From Sale;
    Delete From Customer;
    Delete From Product;
      
    -- INSERT KNOWN DATA
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (221, 'Test Dude 1', 746, 'OK');
    
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1111, 'Test Product 1', 12, 746); 
      
    
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  Values(5, 221, 1111, 11, 6, Sysdate);
      
                          
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  VALUES(8, 221, 1111, 19, 2, SYSDATE);               
      
      
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  VALUES(12, 221, 1111, 2, 321, SYSDATE);               
                 

     EXECUTE IMMEDIATE ('BEGIN ' || USER || '.DELETE_ALL_SALES_FROM_DB; END;');                   

    
      
    SELECT COUNT(*) INTO VCOUNT FROM SALE;
    
    -- CHECK ALL SALES CORRECTLY DELETE
    
    If Vcount = 0 Then 
        Vmarks := Vmarks + 1;
    Else
          Dopl('DELETE_ALL_SALES_FROM_DB - SALES NOT CORRECTLY DELETED');
    End If;
    
  
    Select * Into Vcust From Customer Where Custid = 221;
    Select * Into Vprod From Product Where Prodid = 1111;
      
      
    If  Vcust.Sales_Ytd = 0 THEN
          
        Vmarks := Vmarks + 1;
          
    Else
        Dopl('DELETE_ALL_SALES_FROM_DB - CUSTOMER SALESYTD NOT CORRECTLY UPDATED');
    End If;

    If  VPROD.Sales_Ytd = 0 THEN
          
        Vmarks := Vmarks + 1;
          
    Else
        Dopl('DELETE_ALL_SALES_FROM_DB - PRODUCT SALESYTD NOT CORRECTLY UPDATED');
    End If;      

    
      -- CHECK DELETE_ALL_SALES_VIASQLDEV
    Select Count(*) Into Vcount From Sys.All_Objects
    Where Owner = User And Object_Name = 'DELETE_ALL_SALES_VIASQLDEV';
  
    If Vcount = 1 Then
      Vmarks := Vmarks + 1;
    Else
      Dopl('DELETE_ALL_SALES_VIASQLDEV - EITHER NOT ATTEMPTED OR NOT CORRECT');
    
  End If;

    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/4 Marking points correct FOR DELETE_ALL_SALES_FROM_DB AND DELETE_ALL_SALES_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    

Exception
  When Others Then
    Dopl('code inspection required - ' || SQLERRM);
End;
/
