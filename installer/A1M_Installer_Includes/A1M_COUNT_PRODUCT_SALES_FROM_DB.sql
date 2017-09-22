
set serveroutput on;

Create Or Replace Function A1M_COUNT_PROD_SALES_FROM_DB(Pstartingmarks Number) Return Number AUTHID CURRENT_USER As


  Vcount Integer;
  Vcust Customer%Rowtype;
  Vmarks Integer := Pstartingmarks;

Begin

  -- 3 MARKS ALLOCATED
  
  -- 2 FOR RETURNING CORRECT COUNT
  -- 1 FOR COUNT_PRODUCT_SALES_VIASQLDEV
  

  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'COUNT_PRODUCT_SALES_FROM_DB';

  If Vcount <> 0 Then
    Dopl('COUNT_PRODUCT_SALES_FROM_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE
  
    -- CLEAR ANY EXISTSING CUSTOMERS FROM TABLE
    DELETE FROM SALE;
    Delete From Customer;
    DELETE FROM PRODUCT;

    Commit;
    
    -- ADD KNOWN DATA
  
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (221, 'Test Dude 1', 100, 'OK');
                  
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1111, 'Test Product 1', 10, 50);
                  
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  VALUES(5, 221, 1111, 5, 15, TO_DATE('02-FEB-14'));
                  
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  VALUES(6, 221, 1111, 6, 16, TO_DATE('03-FEB-14'));
    
    
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  Values(7, 221, 1111, 7, 17, TO_DATE('04-FEB-14'));
    
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  VALUES(8, 221, 1111, 8, 18, TO_DATE('29-JAN-14'));
    
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
                  Values(9, 221, 1111, 9, 19, TO_DATE('28-JAN-14'));
    
    -- 5 SALES ADDED
    
    EXECUTE IMMEDIATE  'CALL ' || USER || '.Count_Product_Sales_From_Db(sysdate-to_date(''01-Feb-2014'')) 
                        INTO :VCOUNT' USING OUT VCOUNT;
                    
    -- 3 SALES AFTER 01 FEB 14
    
    If Vcount = 3 Then
      Vmarks := VMarks + 2;
    Else
      Dopl('COUNT_PRODUCT_SALES_FROM_DB NOT RETURNING CORRECT VALUE');
    END IF;



    -- CHECK THAT COUNT_PRODUCT_SALES_VIASQLDEV HAS BEEN ATTEMPTED
    Select Count(*) Into Vcount From Sys.All_Objects
    Where Owner = User And Object_Name = 'COUNT_PRODUCT_SALES_VIASQLDEV';
  
    If Vcount = 0 Then
      Dopl('COUNT_PRODUCT_SALES_VIASQLDEV EITHER NOT ATTEMPTED OR NOT CORRECT');
    Else
      Vmarks := Vmarks + 1;
    END IF;

    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/3 Marking points correct FOR COUNT_PRODUCT_SALES_FROM_DB AND COUNT_PRODUCT_SALES_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    
Exception
    When Others Then
      Dopl('COUNT_PRODUCT_SALES_FROM_DB - GENERATED UNEXPECTED EXCEPTION - ' || SQLERRM);
End;
/


-- BLOCK FOR TESTING

--Begin
--Dopl(A1M_Add_Customer_To_Db(10));
--END;
