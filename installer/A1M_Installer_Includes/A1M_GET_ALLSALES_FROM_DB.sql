
set serveroutput on;

CREATE OR REPLACE FUNCTION A1M_GET_ALLSALES_FROM_DB(pstartingmarkS number) return number AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := pstartingmarkS;
  Vsalesytd Number;
  Vcust Customer%Rowtype;
  Vprod Product%Rowtype;
  Vsale Sale%Rowtype;
  vcur sys_refcursor;
  
Begin 
    
  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'GET_ALLSALES_FROM_DB';

  If Vcount <> 0 Then
    Dopl('GET_ALLSALES_FROM_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE
  
    
    -- clear data from tables
    delete from sale;
    Delete From Customer;
    Delete From Product;

    
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (221, 'Test Dude 1', 0, 'OK');
                  
    Insert Into Customer (Custid, Custname, Sales_Ytd, Status)
                  Values (222, 'Test Dude 2', 0, 'SUSPEND');
    
    Insert Into Product (Prodid, Prodname, Selling_Price, Sales_Ytd)
                  Values (1111, 'Test Product 1', 10, 50); 
    
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
    values  (001, 221, 1111, 1, 11, to_date('20141211', 'yyyymmdd'));
 
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
    values  (002, 221, 1111, 2, 12, to_date('20141212', 'yyyymmdd'));   
    
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
    values  (003, 221, 1111, 3, 13, to_date('20141213', 'yyyymmdd')); 
    
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
    values  (004, 221, 1111, 4, 14, to_date('20141214', 'yyyymmdd')); 
    
    Insert Into Sale (Saleid, Custid, Prodid, Qty, Price, Saledate)
    values  (005, 221, 1111, 5, 15, to_date('20141215', 'yyyymmdd')); 
    
  Begin
  
    Select Count(*) Into Vcount From Sale;
    
    EXECUTE IMMEDIATE  'CALL ' || USER || '.GET_ALLSALES_FROM_DB() INTO :Vcur' USING OUT Vcur;
      
    Loop
        Fetch Vcur Into Vsale;
            Exit When Vcur%Notfound;
              Vcount := Vcount -1;
    End Loop;
    
    If Vcount = 0 Then
        VMARKS := VMARKS + 1;
       
    Else
        Dopl('GET_ALLSALES_FROM_DB - CORRECT CURSOR NOT RETURNED');
    End If;
    
  Exception
   When Others Then
    Dopl('GET_ALLSALES_FROM_DB GENERATED UNEXPECTED EXCEPTION');
  END;
  
    -- CHECK IGET_ALLSALES_VIASQLDEV
    
  Select Count(*) Into Vcount From Sys.All_Objects
  Where Owner = User And Object_Name = 'GET_ALLSALES_VIASQLDEV';
  
  If Vcount = 1 Then
    VMARKS := VMARKS +1;
  Else
    Dopl('GET_ALLSALES_VIASQLDEV - EITHER NOT ATTEMPTED OR NOT CORRECT');
  End If;

    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/2 Marking points correct FOR GET_ALLSALES_FROM_DB AND GET_ALLSALES_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    
Exception
When Others Then
Dopl('ERROR MARKING GET_ALLSALES_FROM_DB - ' || SQLERRM);
End;
/
