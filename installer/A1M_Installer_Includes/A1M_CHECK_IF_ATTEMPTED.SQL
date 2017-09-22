CREATE OR REPLACE function A1M_CHECK_IF_ATTEMPTED(PNAME VARCHAR2) return boolean AUTHID CURRENT_USER AS

  Vcount Integer;
Begin 
  
  --dbms_output.put_line(USER || ' check if attempted');

  -- CHECK IF function / procedure exists
  Select Count(*) Into Vcount From Sys.All_Objects
  Where Owner = User And Object_Name = UPPER(PNAME);
    
  If Vcount = 0 Then
    return false;
    ELSE
    return true;
  END IF;
End;
/