MODULE Module1
    CONST robtarget PocetnaPozicija0:=[[0,-50,0],[1,0,0,0],[1,-1,2,4],[-101.964427132,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget DozerL:=[[0,-50,0],[1,0,0,0],[1,0,1,4],[-101.96443337,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget DozerL_Podignuta:=[[0,-61,0],[1,0,0,0],[1,0,1,4],[-101.96443337,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget DozerP:=[[0,-50,0],[1,0,0,0],[1,1,0,4],[-101.964429518,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget DozerP_Podignuta:=[[0,-61,0],[1,0,0,0],[1,1,0,4],[-101.964429518,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget MedjuPozicija:=[[0,-50,0],[1,0,0,0],[1,0,1,4],[-101.964433413,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget IznadCase:=[[260.103,-37.879,124.7],[0.707106781,-0.707106781,0,0],[1,1,1,4],[121.964437875,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget NakrenutaFlasa:=[[260.103,-37.879,124.7],[0.130526192,-0.991444861,0,0],[1,1,1,4],[121.964437875,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PERS tasks task_list{2}:=[["T_ROB_L"],["T_ROB_R"]];
    PERS num count1 := 0;
    PERS num count2 := 0;
    PERS num count3 := 0;
    PERS num count4 := 1;
    PERS num count5 := 0;
    PERS num bExit1 := 5;
    VAR num tmp1 := 0;
    VAR syncident cep_skinut;
    VAR syncident cep_sipano;
    VAR syncident zavrnuto;
    VAR syncident desna_uzela_flasu;
    VAR syncident desna_pustila_flasu;
    VAR syncident sok;
    VAR syncident ucitane_vrednosti;
    VAR syncident ucitan_izlaz;
    VAR syncident doneta_flasica;
    VAR syncident ucitana_vrednost;
    
    PROC main()
        VAR num bExit2:=1;
        
        TPReadFK bExit1, "Pritisnite dugme Zapocni ukoliko zelite da napravite koktel a Zavrsi u suprotnom", "Zapocni", stEmpty, stEmpty, stEmpty, "Zavrsi";
        
        WHILE bExit1=1 DO
            count1 := 0;
            count2 := 0;
            count3 := 0;
            count4 := 0;
            count5 := 0;
            bExit2 := 1;
            WHILE bExit2=1 DO
                TPReadFK tmp1, "Odaberite sastojak koji zelite da ubacite u koktel", "Pomorandza", "Limun", "Fanta", "Sprite", "CocaCola";
                IF tmp1 = 1 THEN
                    count1:=count1+1;
                ELSEIF tmp1 = 2 THEN
                    count2:=count2+1;
                ELSEIF tmp1 = 3 THEN
                    count3:=count3+1;
                ELSEIF tmp1 = 4 THEN
                    count4:=count4+1;
                ELSEIF tmp1 = 5 THEN
                    count5:=count5+1;
                ENDIF
                TPReadFK bExit2, "Pritisnite dugme Dodaj za novi sastojak ili Zavrsi u suprotnom", "Dodaj", stEmpty, stEmpty, stEmpty, "Zavrsi";
            ENDWHILE
            
            IF count3 > 1 OR count4 > 1 OR count5 > 1 THEN
                WaitSyncTask ucitana_vrednost,task_list;
                TPWrite("Nemoguce je napraviti koktel sa unetim vrednostima");
            ELSE
                WaitSyncTask ucitana_vrednost,task_list;
                IF count3 > 0 THEN
                    SipajGazirano;
                ENDIF
                IF count4 > 0 THEN
                    SipajGazirano;
                ENDIF
                IF count5 > 0 THEN
                    SipajGazirano;
                ENDIF
                IF count1>0 OR count2>0 THEN
                    PokupiCasu;
                ENDIF
                IF count1>0 THEN
                    UradiMedjuKorak;
                ENDIF
                WHILE count1>0 DO
                    SipajPomorandzu;
                    count1 := count1-1;
                ENDWHILE
                IF count2>0 THEN
                    UradiMedjuKorak;
                ENDIF
                WHILE count2>0 DO
                    SipajLimunadu;
                    count2 := count2-1;
                ENDWHILE  
                OstaviCasu;
            ENDIF
            TPReadFK bExit1, "Pritisnite dugme Zapocni za novi koktel ili Zavrsi u suprotnom", "Zapocni", stEmpty, stEmpty, stEmpty, "Zavrsi";
        ENDWHILE
    ENDPROC
    
    
    PROC SipajGazirano()
        DodjiDoFlase;
        WaitSyncTask \InPos,doneta_flasica,task_list;
        Zgrabi;
        WaitSyncTask \InPos,desna_uzela_flasu,task_list;
        WaitSyncTask \InPos,cep_skinut,task_list;
        Sipaj;
        OkreniNatrag;
        WaitSyncTask \InPos,cep_sipano,task_list;
        WaitSyncTask \InPos,zavrnuto,task_list;
        Pusti;
        WaitSyncTask \InPos,desna_pustila_flasu,task_list;
    ENDPROC
    PROC SipajLimunadu()
        MoveL DozerL,v1000,z100,Servo\WObj:=CasaLimunada;
        MoveL DozerL_Podignuta,v1000,z100,Servo\WObj:=CasaLimunada;
        WaitTime \InPos,2;
        MoveL DozerL,v1000,z100,Servo\WObj:=CasaLimunada;
    ENDPROC
    PROC PokupiCasu()
        MoveL PocetnaPozicija0,v1000,z100,Servo\WObj:=PocetakCasa;
        Zgrabi;
    ENDPROC
    PROC OstaviCasu()
        MoveL PocetnaPozicija0,v1000,z100,Servo\WObj:=PocetakCasa;
        Pusti;
    ENDPROC
    PROC SipajPomorandzu()
        MoveL DozerP,v1000,z100,Servo\WObj:=CasaPomorandza;
        MoveL DozerP_Podignuta,v1000,z100,Servo\WObj:=CasaPomorandza;
        WaitTime \InPos,2;
        MoveL DozerP,v1000,z100,Servo\WObj:=CasaPomorandza;
    ENDPROC
    PROC UradiMedjuKorak()
        MoveL MedjuPozicija,v1000,z100,Servo\WObj:=MedjuKorak;
    ENDPROC
    PROC DodjiDoFlase()
        MoveL IznadCase,v1000,z100,Servo\WObj:=FlasicaR1;
    ENDPROC
    PROC Sipaj()
        MoveL NakrenutaFlasa,v1000,z100,Servo\WObj:=FlasicaR1;
    ENDPROC
    PROC OkreniNatrag()
        MoveL NakrenutaFlasa,v1000,z100,Servo\WObj:=FlasicaR1;
        MoveL IznadCase,v1000,z100,Servo\WObj:=FlasicaR1;
    ENDPROC
    PROC Zgrabi()
        g_GripIn;
        WaitTime\InPos,0.5;
    ENDPROC
    PROC Pusti()
        g_JogOut;
        WaitTime\InPos,0.5;
    ENDPROC
ENDMODULE