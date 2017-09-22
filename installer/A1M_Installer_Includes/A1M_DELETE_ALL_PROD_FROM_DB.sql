
set serveroutput on;

CREATE OR REPLACE FUNCTION A1M_DELETE_ALL_PROD_FROM_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  VCOUNT INTEGER;
  Vcount1 Number;
  Vcount2 Integer;
  Vprod Product%Rowtype;
  Vmarks Integer := PSTARTINGMARKS;
  Vsubmark Integer := 0;

Begin 

 SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'DELETE_ALL_PRODUCTS_FROM_DB';

  If Vcount <> 0 Then
    Dopl('DELETE_ALL_PRODUCTS_FROM_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE

  
    -- CLEAR ANY EXISTING PRODUCTS FROM TABLE
    DELETE FROM SALE;
    Delete From Product;
    

    -- insert a known number of PRODUCTS.
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1001, 'Test Product 1', 10, 0);
              
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1002, 'Test Product 2', 20, 0);
              
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1003, 'Test Product 3', 30, 0);
                  
                  
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1004, 'Test Product 4', 40, 0);

    -- call the function to be tested     

    EXECUTE IMMEDIATE  'CALL ' || USER || '.Delete_All_products_From_Db() INTO :VCOUNT1' USING OUT VCOUNT1;

    --Vcount1 := Delete_All_products_From_Db;

    -- check number of rows remaining in DB
    Select Count(*) Into Vcount2 from product;
  
    -- check that sll PRODUCTS deleted
    If Vcount2 = 0 Then
      Vmarks := Vmarks + 1;
      Else
      Dopl('DELETE_ALL_PRODUCTS_FROM_DB ALL PRODUCTS NOT CORRECTLY DELETED');
    End If;
    
    -- check that correct value is returned
    If Vcount1 = 4 Then
      Vmarks := Vmarks + 1;
      Else
      Dopl('DELETE_ALL_PRODUCTS_FROM_DB INCORRECT RETURN VALUE');
    end if;

  -- CHECK THAT ADD_PRODUCT_VIASQLDEV  HAS BEEN ATTEMPTED
  Select Count(*) Into Vcount2 From Sys.All_Objects
  Where Owner = User And Object_Name = 'DELETE_ALL_PRODUCTS_VIASQLDEV';
  
  If Vcount2 = 1  Then
    Vmarks := Vmarks + 1;
  Else
    Dopl('ALL VIASQLDEV PROCEDURES EITHER NOT ATTEMPTED OR NOT CORRECT');
  End If;

    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/3 Marking points correct FOR DELETE_ALL_PRODUCTS_FROM_DB AND DELETE_ALL_PRODUCTS_VIASQLDEV');
    Return Vmarks;
  END IF;
    
Exception
When Others Then
Dopl('code inspection required - ' || SQLERRM);
End;
/

-- BLOCK FOR TESTING

--Begin
--Dopl(A1M_DELETE_ALL_PROD_FROM_DB(10));
--END;

