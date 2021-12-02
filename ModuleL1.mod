MODULE Module1
    CONST robtarget Target_20:=[[0,0,0],[0.707106781,0.707106781,0,0],[0,0,0,0],[101.964427132,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget PocetnaPozicija1:=[[0,0,45],[0,0.707106781,0.707106781,0],[-1,2,1,4],[121.964437305,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget IznadCase:=[[0,0,50],[0,0.707106781,0.707106781,0],[-1,2,1,4],[121.964437875,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget OdvrnutCep:=[[0,0,50],[0,-0.707106781,0.707106781,0],[-1,2,1,4],[121.964437875,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget SklonjenCep:=[[0,150,80],[0,-0.707106781,0.707106781,0],[-1,2,-2,4],[121.964437875,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget PocetnaPozicija2:=[[75,0,45],[0,0.707106781,0.707106781,0],[-1,2,1,4],[121.964437305,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget PocetnaPozicija3:=[[150,0,45],[0,0.707106781,0.707106781,0],[-1,2,1,4],[121.964437305,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PERS tasks task_list{2}:=[["T_ROB_L"],["T_ROB_R"]];
    PERS num count1;
    PERS num count2;
    PERS num count3;
    PERS num count4;
    PERS num count5;
    PERS num bExit1;
    VAR syncident cep_skinut;
    VAR syncident cep_sipano;
    VAR syncident zavrnuto;
    VAR syncident desna_uzela_flasu;
    VAR syncident desna_pustila_flasu;
    VAR syncident ucitane_vrednosti;
    VAR syncident ucitan_izlaz;
    VAR syncident doneta_flasica;
    CONST jointtarget PocetniUgao:=[[-96.878269376,-128.650478904,66.411568545,193.682868332,129.87287786,224.893333333],[99.719170448,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget Ugao450:=[[-96.878269376,-128.650478904,66.411568545,193.682868332,129.87287786,-224.893333333],[99.719170448,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR syncident ucitana_vrednost;
    
    PROC main()
        g_Init;
        g_JogOut;
        
        WHILE bExit1=1 DO
            WaitSyncTask ucitana_vrednost,task_list;
            IF count3 = 1 THEN
                DonesiFlasicu1;
                OdvrniZavrni;
                OdnesiFlasicu1;
            ENDIF
            IF count4 = 1 THEN
                DonesiFlasicu2;
                OdvrniZavrni;
                OdnesiFlasicu2;
            ENDIF
            IF count5 = 1 THEN
                DonesiFlasicu3;
                OdvrniZavrni;
                OdnesiFlasicu3;
            ENDIF
        ENDWHILE
    ENDPROC
    
    PROC OdvrniZavrni()
        WaitSyncTask \InPos,doneta_flasica,task_list;
        MoveAbsJ PocetniUgao,v1000,z100,Servo\WObj:=wobj0;
        WaitSyncTask \InPos,desna_uzela_flasu,task_list;
        OdvrtanjeCepa;
        PomeriCep;
        WaitSyncTask \InPos,cep_skinut,task_list;
        WaitSyncTask \InPos,cep_sipano,task_list;
        VratiCep;
        ZavrtanjeCepa;
        WaitSyncTask \InPos,zavrnuto,task_list;
        WaitSyncTask \InPos,desna_pustila_flasu,task_list;
    ENDPROC
    PROC DonesiFlasicu1()
        MoveL PocetnaPozicija1,v1000,z100,Servo\WObj:=FlasaPocetnaPozicija;
        Zgrabi;
        MoveL IznadCase,v1000,z100,Servo\WObj:=FlasaIznadCase;
    ENDPROC
    PROC ZavrtanjeCepa()
        MoveAbsJ PocetniUgao,v1000,z100,Servo\WObj:=wobj0;
        Pusti;
        MoveAbsJ Ugao450,v1000,z100,Servo\WObj:=wobj0;
        Zgrabi;
        MoveAbsJ PocetniUgao,v1000,z100,Servo\WObj:=wobj0;
    ENDPROC
    PROC PomeriCep()
        MoveAbsJ Ugao450,v1000,z100,Servo\WObj:=wobj0;
        MoveJ SklonjenCep,v1000,z100,Servo\WObj:=FlasaIznadCase;
    ENDPROC
    PROC VratiCep()
        MoveJ SklonjenCep,v1000,z100,Servo\WObj:=FlasaIznadCase;
        MoveAbsJ Ugao450,v1000,z100,Servo\WObj:=wobj0;
    ENDPROC
    PROC OdvrtanjeCepa()
        MoveAbsJ Ugao450,v1000,z100,Servo\WObj:=wobj0;
        Pusti;
        MoveAbsJ PocetniUgao,v1000,z100,Servo\WObj:=wobj0;
        Zgrabi;
        MoveAbsJ Ugao450,v1000,z100,Servo\WObj:=wobj0;
    ENDPROC
    PROC OdnesiFlasicu1()
        MoveL IznadCase,v1000,z100,Servo\WObj:=FlasaIznadCase;
        Pusti;
        MoveL PocetnaPozicija1,v1000,z100,Servo\WObj:=FlasaPocetnaPozicija;
    ENDPROC
    PROC DonesiFlasicu2()
        MoveL PocetnaPozicija2,v1000,z100,Servo\WObj:=FlasaPocetnaPozicija;
        Zgrabi;
        MoveL IznadCase,v1000,z100,Servo\WObj:=FlasaIznadCase;
    ENDPROC
    PROC OdnesiFlasicu2()
        MoveL IznadCase,v1000,z100,Servo\WObj:=FlasaIznadCase;
        Pusti;
        MoveL PocetnaPozicija2,v1000,z100,Servo\WObj:=FlasaPocetnaPozicija;
    ENDPROC
    PROC DonesiFlasicu3()
        MoveL PocetnaPozicija3,v1000,z100,Servo\WObj:=FlasaPocetnaPozicija;
        Zgrabi;
        MoveL IznadCase,v1000,z100,Servo\WObj:=FlasaIznadCase;
    ENDPROC
    PROC OdnesiFlasicu3()
        MoveL IznadCase,v1000,z100,Servo\WObj:=FlasaIznadCase;
        Pusti;
        MoveL PocetnaPozicija3,v1000,z100,Servo\WObj:=FlasaPocetnaPozicija;
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