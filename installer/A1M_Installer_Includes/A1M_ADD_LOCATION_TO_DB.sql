
set serveroutput on;


CREATE OR REPLACE FUNCTION A1M_ADD_LOCATION_TO_DB(PSTARTINGMARKS NUMBER) RETURN NUMBER AUTHID CURRENT_USER AS

  Vcount Integer;
  Vmarks Integer := PSTARTINGMARKS;
  Vsalesytd Number;
  Vloc Location%Rowtype;
  Vsubmarks Integer := 0;
  
  
Begin 
  
  SELECT COUNT(*) INTO VCOUNT FROM NOT_ATTEMPTED WHERE UPPER(FNAME) = 'ADD_LOCATION_TO_DB';

  If Vcount <> 0 Then
    Dopl('ADD_LOCATION_TO_DB NOT ATEMPTED');
    RETURN Pstartingmarks;
  ELSE
    -- clear the location table
    Delete From Location;

    Begin
      
      -- ADD KNOWN LOACTION VALUES
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Location_To_Db(''loc01'', 103, 507);END;');
      
    
      -- there should be only one lcation in table so select it into vloc
      Select * Into Vloc From Location;
    
      If Vloc.Locid = 'loc01' 
          And Vloc.Minqty = 103 
          And Vloc.Maxqty = 507 Then
        
        Vmarks := Vmarks + 1;
      
      Else 
        Dopl('ADD_LOCATION_TO_DB LOCATION NOT CORRCECTLY ADDED');
      END IF;
    
    Exception
      When Others Then
        Dopl('ADD_LOCATION_TO_DB GENERATED UNEXPECTED EXCEPTION');
    end;
     
-- TEST THE EXCEPTIONS

  -- ENTER DUPLICATE LOCATION ID
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Location_To_Db(''loc01'', 100, 500);END;');
      
    
      -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('ADD_LOCATION_TO_DB DID NOT GENERATE DUPLICATE LOCATION ID EXCEPTION');
    
    Exception
      When Others Then
        If Sqlcode = -20081 
            And Upper(Sqlerrm) Like '%DUPLICATE%'
            And Upper(Sqlerrm) Like '%LOCATION%'
            And Upper(Sqlerrm) Like '%ID%' Then
            
            Vmarks := Vmarks + 1;
        Else
            Dopl('ADD_LOCATION_TO_DB DUPLICATE LOCATION ID EXCEPTION NOT CORRECT');
        End If;
  
  End;
  
   -- ENTER LOCID OF INVALID LENGTH
   
   -- TOO LONG LOC ID ( GENERATES A DIFFERENT EXCEPTION TO A TOO SHORT LOC ID, BOTH NEED TO BE CAUGHT )
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Location_To_Db(''loc002'', 100, 500);END;');
      
    
    -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('CHECK_LOCIDCODE_LENGTH LOCATION CODE INVALID LENGTH EXCEPTION NOT RAISED');
    
    Exception
      When Others Then
        If Sqlcode = -20082 
            And Upper(Sqlerrm) Like '%LOCATION%'
            And Upper(Sqlerrm) Like '%CODE%' 
            And Upper(Sqlerrm) Like '%LENGTH%' 
            And Upper(Sqlerrm) Like '%INVALID%' Then
            
            Vsubmarks := Vsubmarks + 1;
            
        Else
            Dopl('ADD_LOCATION_TO_DB LOCATION CODE LENGTH INVALID EXCEPTION NOT CORRECT');
        End If;
  
    End; 
    
    
    -- TOO SHORT LOC ID ( GENERATES A DIFFERENT EXCEPTION TO A TOO LONG LOC ID, BOTH NEED TO BE CAUGHT )
    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Location_To_Db(''lo02'', 100, 500);END;');
      
    
    -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('CHECK_LOCIDCODE_LENGTH LOCATION CODE LENGTH INVALID (TOO LONG) EXCEPTION NOT RAISED');
    
    Exception
      When Others Then
        If Sqlcode = -20082 
            And Upper(Sqlerrm) Like '%LOCATION%'
            And Upper(Sqlerrm) Like '%CODE%' 
            And Upper(Sqlerrm) Like '%LENGTH%' 
            And Upper(Sqlerrm) Like '%INVALID%' Then
            
            Vsubmarks := Vsubmarks + 1;
            
            Else
            Dopl('ADD_LOCATION_TO_DB LOCATION CODE LENGTH INVALID (TOO SHORT) EXCEPTION NOT CORRECT');
        End If;
  
    End; 
    
    If Vsubmarks = 2 Then
      Vmarks := Vmarks + 1;
    Else
      Dopl('ADD_LOCATION_TO_DB LOCATION CODE LENGTH INVALID EXCEPTION NOT CORRECT');
    End If;
    
    Vsubmarks := 0;
    
    -- ENTER INVALID MINIMUM QTY

    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Location_To_Db(''loc03'', -1, 500);END;');
      
      
      -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('ADD_LOCATION_TO_DB CHECK_MINQTY_RANGE EXCEPTION NOT RAISED');
    
    Exception
      When Others Then
        If Sqlcode = -20083 
            And Upper(Sqlerrm) Like '%MINIMUM%'
            And Upper(Sqlerrm) Like '%QTY%' 
            And Upper(Sqlerrm) Like '%OUT%' 
            And Upper(Sqlerrm) Like '%OF%' 
            And Upper(Sqlerrm) Like '%RANGE%' Then
            
            Vsubmarks := Vsubmarks + 1;

        Else
            Dopl('ADD_LOCATION_TO_DB Minimum Qty out of range EXCEPTION NOT CORRECT');
        End If;
  
    End;


    -- ENTER INVALID MINIMUM QTY

    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Location_To_Db(''loc04'', 100, 1000);END;');
      
      -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('ADD_LOCATION_TO_DB CHECK_MAXQTY_RANGE EXCEPTION NOT RAISED');
    
    Exception
      When Others Then
        If Sqlcode = -20084 
        And Upper(Sqlerrm) Like '%MAXIMUM%'
        And Upper(Sqlerrm) Like '%QTY%'
        And Upper(Sqlerrm) Like '%OUT%'
        And Upper(Sqlerrm) Like '%OF%'
        And Upper(Sqlerrm) Like '%RANGE%' Then
        
            Vsubmarks := Vsubmarks + 1;

        Else
            
            Dopl('ADD_LOCATION_TO_DB Maximum Qty out of range EXCEPTION NOT CORRECT');
            
        End If;
  
    End;

  
    -- ENTER A MIN QTY LARGER THAN MAX QTY

    Begin
      EXECUTE IMMEDIATE ('BEGIN ' || USER || '.Add_Location_To_Db(''loc01'', 500, 400);END;');
      
    
      -- THIS WILL ONLY EXECUTE IF EXPECTED EXCEPTION IS NOT RAISED
      Dopl('ADD_LOCATION_TO_DB CHECK_MAXQTY_GREATER_MIXQTY EXCEPTION NOT RAISED');
    
    Exception
      When Others Then
        If Sqlcode = -20086 -- altered 
            And Upper(Sqlerrm) Like '%MINIMUM%'
            And Upper(Sqlerrm) Like '%LARGER%'
            And Upper(Sqlerrm) Like '%MAXIMUM%'
            And Upper(Sqlerrm) Like '%QTY%' Then
            
            VSUBmarks := VSUBmarks + 1;

        Else
            Dopl('ADD_LOCATION_TO_DB CHECK_MAXQTY_GREATER_MIXQTY EXCEPTION NOT CORRECT');
        End If;
  
    End;
    
    
    If Vsubmarks = 3 Then
      Vmarks := Vmarks + 1;
    Else
      Dopl('ADD_LOCATION_TO_DB MAX / MIN QTY EXCEPTION/S NOT CORRECT');
    End If;
    
    Vsubmarks := 0;
    
  
    -- CHECK FOR ADD_LOCATION_VIASQLDEV
  
    Select Count(*) Into Vcount From Sys.All_Objects
    Where Owner = User And Object_Name = 'ADD_LOCATION_VIASQLDEV';
  
    If Vcount = 1 Then
      Vmarks := Vmarks + 1;
    Else
      Dopl('ADD_LOCATION_VIASQLDEV EITHER NOT ATTEMPTED OR NOT CORRECT');
    END IF;

    -- output the marks    
    Dopl( Vmarks - PSTARTINGMARKS || '/5 Marking points correct FOR ADD_LOCATION_TO_DB AND ADD_LOCATION_VIASQLDEV');
    RETURN VMARKS;  
  END IF;
    
Exception

When Others Then
  Dopl('ERROR MARKING ADD_LOCATION_TO_DB - ' || SQLERRM);
End;
/
