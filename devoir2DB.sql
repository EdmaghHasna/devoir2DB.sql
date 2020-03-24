///// GROUP :  CHATI CHAIMA
/////////// EDMAGH HASNA 



////////////////////// C7
DECLARE 
CURSOR C_pilote IS   
SELECT nom, sal, comm
FROM pilote 
WHERE nopilot BETWEEN 1280 AND 1999 FOR UPDATE;
v_nom pilote.nom%type; 
v_sal pilote.sal%TYPE;
v_comm pilote.comm%TYPE; 
BEGIN 

    OPEN C_pilote;
 LOOP
 FETCH C_pilote INTO v_nom , v_sal , v_comm;
 EXIT WHEN C_pilote%NOTFOUND;
 IF (v_comm> v_sal) THEN 
{
    UPDATE PILOTE SET SAL = v_sal+ v_comm AND v_comm=0  WHERE CURRENT OF C_pilote;
	 dbms_output.put_line (num || ' mis a jour.');
}
ELSEIF(v_comm == 0) THEN
{
  DELETE FROM  PILOTE WHERE CURRENT OF C_pilote ;
  dbms_output.put_line (num || ' was delete.');
}


END IF ;

END LOOP;
 
CLOSE C_pilote;
 
END;
/

///////////////////// C8


create or replace procedure pr_Pilote( Nopil in PILOTE.NOPILOT%type ) IS
Erreur_comm exception ;
P_pilot PILOTE%rowtype 
begin
  
Select  NOPILOT,SAL ,COMM into P_pilot From Pilote WHERE PILOTE.NOPILOT=Nopil ;

If P_pilot.COMM > P_pilot.SAL 
Then
Raise erreur_comm ;

    
EXECPTION
When NO_DATA_FOUND Then
Insert into erreur VALUES(P_pilot.NOPILOTE,'NOM PILOTE-OK') ;
When DATA_FOUND Then
Insert into erreur VALUES(P_pilot.NOPILOTE,'PILOTE INCONNU') ;
When erreur_comm then
Insert into erreur VALUES(v_pilot.nom, 'Commission > salaire') ;

END ;
/


////////////////////////D1

CREATE VIEW v_pilote AS SELECT * from pilote where ville='PARIS';

//////////////////////D2
update v_pilote set SAL =SAL*10 ;
SELECT * from v_pilote  ;

////"Il n'est pas possible de modifier les salaires des pilotes habitant Paris à travers la vue v-pilote"//

///////////////D3
CREATE VIEW dervol1 AS select avion,MAX(date_vol )as max
from affectation 
group by avion ;


///////////////////////D4 
CREATE VIEW cr_pilote as select * from pilote WHERE (COMM is NOT null and VILLE='PARIS') OR (COMM is NULL and Ville<>'PARIS')
WITH CHECK OPTION ;

/////////////////////////////////////D5
create view nomcomm as select * from pilote where (NOPILOT NOT IN (select PILOTE from affectation ) AND COMM is null)  OR (NOPILOT IN (select PILOTE from affectation) AND COMM is not null )
WITH CHECK OPTION;





