100 REMark *
110 REMark * S.P.A.C.E. Demonstration program
120 REMark * by Oliver Fink    18/06/90
130 REMark *
140 REMark * Jobname : SpaceDemo
150 REMark *
160 REMark * Updated : --/--/--
170 REMark *
180 REMark * QLib Information : no cmdline, no windows, no lines, no names
190 REMark *
200 REMark * assembler moduls : qptr_rext       - Qjump
210 REMark *                    spacextn_bin    - O.Fink
220 REMark *                    (QLib runtimes)
230 REMark *
240 :
1000 REMark $$stak=2048
1010 REMark $$asmb=flp2_spacextn_bin,0,10
1020 :
1030 :
1040 RESTORE 
1050 DIM menu$(10,20),selc$(5,10),info$(4,60)
1060 :
1070 : REMark create application main window
1080 FOR i=0 TO 3:READ menu$(i)
1090     DATA 'Help','Paper','Shape','Exit'
1100 demo_app=CR_APP(300,80,150,5;'SPACE Demonstration\SpaceDemo',128+8+2+1,menu$(TO 3),0,7)
1110 :
1120 : REMark create sub command window for shape
1130 FOR i=0 TO 5:READ menu$(i)
1140     DATA 'Circle','Square','Line','Disk (filled)','Block','Point'
1150 CR_MENU demo_app,2,menu$(TO 5),0
1160 :
1170 : REMark open channel
1180 OPEN #1;'con_2x1a0x0':OPEN #3;'con_2x1a0x0'
1190 :
1200 : REMark draw application
1210 DR_APP #1;demo_app
1220 :
1230 pap=7:shape=0
1240 REPeat loop
1250     why=RD_APP(#1;#3,demo_app)
1260     SELect ON why
1270        =0 : x=.74*X_PTR(demo_app) : y=80-Y_PTR(demo_app)
1280             SCALE #3;80,0,0
1290             INK #3;RND(0 TO 255)
1300             SELect ON shape=3,4 : FILL #3;1
1310             SELect ON shape
1320                =0,3 : CIRCLE #3;x,y,20
1330                =1,4 : LINE #3;x,y TO x+20,y TO x+20,y+20 TO x,y+20 TO x,y
1340                =2 : LINE #3;x,y TO x+RND(-20 TO 20),y+RND(-20 TO 20)
1350                =5 : POINT #3;x,y
1360             END SELect 
1370             FILL #3;0
1380        =2 : PAPER #3;pap : CLS #3
1390        =10: nr=COMM_NR(demo_app)
1400             SELect ON nr
1410                =0 : BEEP 1000,10
1420                =1 : info$(0)="Please select the paper colour from"
1430                     info$(1)="from one of the following items:"
1440                     selc$(0)="black":selc$(1)="red"
1450                     selc$(2)="green":selc$(3)="white"
1460                     pap=2*BX_SELECT(info$(TO 1),selc$(TO 3),0)
1470                =2 : shape=SUBC_NR(demo_app)
1480                =3 : EXIT loop
1490             END SELect 
1500     END SELect 
1510 END REPeat loop
1520 :
1530 RM_APP demo_app
1540 STOP
31000 DEFine FuNction CR_APP(w,h,x,y,name$,ev_byte%,mcom$,pointer,colr)
31005   LOCal xx,l_anz,pos,i,wx,wy,fsx,fpx,p1,p2,posy,ky$(1),ca%(3)
31010   IF DIMN(colr)=0 THEN set_arr3 ca%;0,1,4,colr:ELSE FOR i=0 TO 3:ca%(i)=colr(i)
31015   p1=0:p2=0:IF DIMN(pointer)<>0 THEN p1=pointer(0):p2=pointer(1):ELSE p1=pointer:p2=pointer
31020   spr_p=0:str_p=0
31025   wx=w+8:wy=h+3+14+14*(DIMN(mcom$)<>0)
31030   fxs=wx-4:fpx=2
31035   xx='\' INSTR name$:IF xx THEN but$=name$(xx+1 TO LEN(name$)):name$=name$(1 TO xx-1):ELSE but$=JOB$(-1)
31040   IF LEN(but$)>15 THEN but$=but$(1 TO 15)
31045   :
31050   DIM wattr%(3),wdef%(3),imod(1)
31055   DIM iwattr%(1,3),iwdef%(1,3)
31060   DIM attr(3,3),l_size%(13,1),l_org%(13,1),l_jus%(13,1),l_type%(13)
31065   DIM l_strg$(13,50),l_pspr(13),l_pblb(13),l_ppat(13)
31070   l_sk$=""
31075   :
31080   attr(0,0)=1:attr(1,0)=7:attr(1,1)=4
31085   attr(2,0)=7:attr(2,1)=0:attr(3,0)=4:attr(3,1)=7
31090   set_arr3 wattr%;2,1,0,7
31095   :
31100   area=ALCHP(1024)             : REMark some working space
31105   POKE_L area,S_ADDR
31110   :
31115   l_anz=-1                        : REMark running counter for loose items
31120   POKE_L area+88,-1               : REMark init item number marker
31125   :
31130   : REMark set cancel item
31135   fxs=fxs-24
31140   IF ev_byte%&&1 THEN 
31145      set_loose l_anz;18,11,wx-22,2;CHR$(7),2+256,'',PEEK_L(area)+272
31150   ELSE 
31155      set_loose l_anz;18,11,wx-22,2;CHR$(3),256,'ESC',0
31160   END IF 
31165   POKE area+91,l_anz
31170   :
31175   : REMark set wake item (if any)
31180   IF ev_byte%&&2
31185      fxs=fxs-22
31190      pos=wx-22*2
31195      set_loose l_anz;18,11,pos,2;CHR$(8),2+256,'',PEEK_L(area)+168
31200      POKE area+90,l_anz
31205   END IF 
31210   :
31215   : REMark set move item (if any)
31220   pos=4
31225   IF ev_byte%&&8
31230      fxs=fxs-24:fpx=fpx+24
31235      set_loose l_anz;18,11,4,2;CHR$(5),2+256,'',PEEK_L(area)
31240      pos=28
31245      POKE area+88,l_anz
31250   END IF 
31255   :
31260   : REMark set resize item (if any)
31265   IF ev_byte%&&4
31270      fxs=fxs-24:fpx=fpx+24
31275      set_loose l_anz;18,11,pos,2;CHR$(6),2+256,'',PEEK_L(area)+88
31280      POKE area+89,l_anz
31285   END IF 
31290   POKE area+87,l_anz+1
31295   :
31300   : REMark set menu items
31305   pos=4:ypos=16
31310   FOR i=0 TO DIMN(mcom$)-(DIMN(mcom$)=0)
31315      IF i<=5 THEN ky$=CHR$(232+4*i):ELSE ky$=CHR$(234+4*(i-5))
31320      IF i=0 THEN ky$=CHR$(4)
31325      IF pos+56>w THEN pos=4:ypos=ypos+12:wy=wy+12
31330      set_loose l_anz;50,10,pos,ypos;ky$,256,mcom$(i),0
31335      pos=pos+54
31340   END FOR i
31345   :
31350   : REMark set up loose item list
31355   POKE_W area+84,l_anz
31360   POKE area+86,ev_byte%
31365   POKE_L area+8,MK_LIL(attr,l_size%(TO l_anz),l_org%(TO l_anz),l_jus%(TO l_anz),l_sk$,l_type%(TO l_anz),l_strg$(TO l_anz),l_pspr(TO l_anz),l_pblb(TO l_anz),l_ppat(TO l_anz))
31370   :
31375   : REMark setup information object list
31380   l_size%(0,0)=6*LEN(name$):l_size%(0,1)=10
31385   l_org%(0,0)=3:l_org%(0,1)=0:imod(0)=0
31390   l_type%(0)=0:l_strg$(0)=name$
31395   POKE_L area+16,MK_IOL(l_size%(0),l_org%(0),imod(0),l_type%(0),l_strg$(0),l_pblb(0),l_ppat(0))
31400   :
31405   : REMark setup information window list
31410   set_arr3 iwattr%(0);0,0,0,92
31415   set_arr3 iwattr%(1);0,0,0,7
31420   set_arr3 iwdef%(0);fxs,14,fpx,1
31425   set_arr3 iwdef%(1);LEN(name$)*6+6,10,fpx+((fxs-6*LEN(name$)-6) DIV 2),3
31430   imod(0)=0:imod(1)=PEEK_L(area+16)
31435   POKE_L area+24,MK_IWL(iwdef%(TO 1),iwattr%(TO 1),imod(TO 1))
31440   :
31445   : REMark set up application window
31450   set_arr3 iwdef%(0);w,h,4,wy-h-2+(DIMN(mcom$)=0)
31455   POKE_L area+32,MK_APPW(iwdef%(0),ca%,p2,"")
31460   :
31465   : REMark make application window list
31470   imod(0)=PEEK_L(area+32):imod(1)=imod(0)
31475   POKE_L area+40,MK_AWL(imod(TO 1))
31480   :
31485   : REMark set up window defintion
31490   set_arr3 wdef%;wx,wy+(DIMN(mcom$)=0),x,y
31495   POKE_L area+80,MK_WDEF(wdef%,wattr%,p1,PEEK_L(area+8),PEEK_L(area+24),PEEK_L(area+40))
31500   :
31505   : REMark clear menu command slots
31510   FOR i=100 TO 140 STEP 4:POKE_L area+i,0
31515   :
31520   : REMark set up button definition
31525   IF ev_byte%&&1 THEN POKE_L area+76,make_button(area,but$)
31530   POKE_L area+96,-1
31535   RETurn area
31540 END DEFine 
31545 :
31550 REMark ----------------------------------------------------------------
31555 DEFine PROCedure DR_APP(ch,area)
31565   DIM lflg%(13)
31570   IF RMODE<>4 THEN MODE 4
31575   CURDIS #ch
31580   IF JOB$(-1)="" THEN 
31585      DR_PULD PEEK_L(area+80),-1,-1,lflg%(TO PEEK_W(area+84))
31590   ELSE 
31595      DR_PPOS #ch;PEEK_L(area+80),-1,-1,lflg%(TO PEEK_W(area+84))
31600   END IF 
31605 END DEFine 
31610 REMark -----------------------------------------------------------------
31615 DEFine PROCedure RM_APP(area)
31617   FOR i=0 TO 9:IF PEEK_L(area+100+4*i)<>0 THEN RECHP PEEK_L(area+100+4*i)
31620   DR_UNST PEEK_L(area+80):RECHP PEEK_L(area+80)
31625   RECHP area
31630 END DEFine 
31635 REMark ------------------------------------------------------------------
31640 DEFine FuNction COMM_NR(area)
31645   IF PEEK(area+256)=255 THEN RETurn -1:ELSE RETurn PEEK(area+256)
31650 END DEFine 
31655 REMark -------------------------------------------------------------------
31660 DEFine FuNction SUBC_NR(area)
31665   IF PEEK(area+257)=255 THEN RETurn -1:ELSE RETurn PEEK(area+257)
31670 END DEFine 
31675 REMark --------------------------------------------------------------------
31680 DEFine FuNction X_PTR(area)
31685   RETurn PEEK_W(area+260)
31690 END DEFine 
31695 REMark ----------------------------------------------------------------------
31700 DEFine FuNction Y_PTR(area)
31705    RETurn PEEK_W(area+262)
31710 END DEFine Y_PTR
31715 REMark --------------------------------------------------------------------
31720 DEFine FuNction APP_EVENT(area)
31725    RETurn PEEK (area+259)
31730 END DEFine APP_EVENT
31735 REMark ------------------------------------------------------------------
31740 DEFine FuNction RD_APP(ch,ach,area)
31745   LOCal why,loop,it%,sw%,ev%,xr%,yr%,it,dx,dy
31750   POKE_L area+256,-1:POKE_L area+260,-1
31755   REPeat loop
31760      why=-1
31765      RD_PTR PEEK_L(area+80),it%,sw%,ev%,xr%,yr%,lflg%(TO PEEK_W(area+84))
31770      it=it%
31775      IF sw%=-1
31780         SELect ON it
31785           =PEEK(area+88):CLOSE #ach:CH_WIN PEEK_L(area+80)
31787                          OPEN #ach,'con_2x1a0x0'
31790           =PEEK(area+89):CLOSE #ach:CH_WIN PEEK_L(area+80),dx,dy
31795                          POKE_W area+260,dx:POKE_W area+262,dy
31797                          OPEN #ach,'con_2x1a0x0'
31800                          why=4
31805           =PEEK(area+91):IF PEEK(area+86)&&1=1 THEN CLOSE #ach:rd_button #ch;area:why=2:OPEN #ach,'con_2x1a0x0':ELSE :why=1
31810           =PEEK(area+90):why=2
31815           =PEEK(area+87) TO PEEK_W(area+84):menu_nr=it-PEEK(area+87)
31820                          IF PEEK_L(area+100+menu_nr*4)=0
31825                             why=10:POKE area+256,menu_nr
31830                          ELSE 
31835                             rd_menu area,menu_nr
31840                             IF PEEK(area+256)<>255 THEN why=10
31845                          END IF 
31850         END SELect 
31855      END IF 
31860      IF sw%=0 AND NOT(PEEK(area+86)&&128) THEN POKE area+259,it% DIV 256:why=0
31865      IF sw%=0 AND PEEK(area+86)&&128<>0 AND it%&&1=1 THEN POKE area+259,it% DIV 256:why=0
31870      IF why>=0 THEN EXIT loop
31872   END REPeat loop
31876   DR_CHAN #ach;area
31880   IF why=0 THEN POKE_W area+260,xr%:POKE_W area+262,yr%
31885   RETurn why
31890 END DEFine 
31895 REMark ----------------------------------------------------------------
31900 DEFine PROCedure CR_MENU(area,mnr,item$,pointer)
31905   LOCal wdt,inr,nit,lptr
31910   nit=DIMN(item$)
31915   wdt=0:FOR i=0 TO nit:IF LEN(item$(i))>wdt THEN wdt=LEN(item$(i))
31920   wdt=wdt+1
31925   str_p=0:spr_p=0:l_sk$=""
31930   inr=-1:set_loose inr;18,10,wdt*6-14,2;CHR$(3),256,'ESC',0
31935   FOR i=0 TO nit:set_loose inr;wdt*6,10,4,14+i*12;item$(i,1),256,item$(i),0
31940   FOR i=0 TO nit+1:l_jus%(i,0)=0:l_jus%(i,1)=0
31945   lptr=MK_LIL(attr,l_size%(TO nit+1),l_org%(TO nit+1),l_jus%(TO nit+1),l_sk$,l_type%(TO nit+1),l_strg$(TO nit+1),l_pblb(TO nit+1),l_ppat(TO nit+1))
31950   set_arr3 wdef%;wdt*6+8,(nit+2)*12+2,wdt*6,10
31955   set_arr3 wattr%;1,1,4,7
31960   POKE_L area+100+mnr*4,MK_WDEF(wdef%,wattr%,pointer,lptr,0,0)
31965   POKE_W area+44+mnr*2,nit+1
31970 END DEFine CR_MENU
31975 REMark ----------------------------------------------------------------
31980 DEFine PROCedure rd_menu(area,mnr)
31985   LOCal loop,clflg%(20),it%,sw%,ev%,xr%,yr%
31990   DR_PULD PEEK_L(area+100+4*mnr),-1,-1,clflg%(TO PEEK_W(area+44+2*mnr))
31995   REPeat loop
32000      RD_PTR PEEK_L(area+100+4*mnr),it%,sw%,ev%,xr%,yr%,clflg%(TO PEEK_W(area+44+2*mnr))
32005      IF sw%=-1 AND it%<>-1 THEN EXIT loop
32010   END REPeat loop
32015   DR_UNST PEEK_L(area+100+4*mnr)
32020   POKE area+259,ev%
32025   IF it%<>0 THEN POKE area+256,mnr:POKE area+257,it%-1:ELSE POKE_W area+256,-1
32030 END DEFine rd_menu
32035 REMark -----------------------------------------------------------------
32040 DEFine FuNction BX_SELECT(info$,item$,pointer)
32045   LOCal blflg%(8),i,loop,wdt,n_it,n_info,i_cnt,ptr(2)
32050   LOCal addr,it%,sw%,ev%,xr%,yr%,ch
32055   n_info=DIMN(info$):n_it=DIMN(item$):l_sk$=""
32060   wdt=0:FOR i=0 TO n_info:IF wdt<LEN(info$(i)) THEN wdt=LEN(info$(i))
32065   i_cnt=-1:ixs=(wdt*6+4) DIV (n_it+1)
32070   str_p=0
32075   FOR i=0 TO n_it:set_loose i_cnt;ixs-4,13,10+ixs*i,n_info*10+23;item$(i,1),256,item$(i),0:l_jus%(i,0)=0:l_jus%(i,1)=0
32080   ptr(0)=MK_LIL(attr,l_size%(TO n_it),l_org%(TO n_it),l_jus%(TO n_it),l_sk$,l_type%(TO n_it),l_strg$(TO n_it),l_pblb(TO n_it),l_ppat(TO n_it))
32085   set_arr3 iwattr%(0);0,1,4,7
32090   set_arr3 iwattr%(1);0,1,4,7
32095   set_arr3 iwdef%(0);(wdt+2)*6,n_info*10+20,4,2
32100   set_arr3 iwdef%(1);(wdt+2)*6,17,4,n_info*10+21
32105   ptr(1)=MK_IWL(iwdef%(TO 1),iwattr%(TO 1),l_pblb(TO 1))
32110   set_arr3 wattr%;1,1,4,7
32115   set_arr3 wdef%;(wdt+2)*6+8,(n_info+4)*10,20,20
32120   addr=MK_WDEF(wdef%,wattr%,pointer,ptr(0),ptr(1),0)
32125   DR_PULD addr,-1,-1,blflg%(TO n_it)
32130   ch=FOPEN('con'):DR_IWDF #ch;addr,0:STRIP #ch;7:INK #ch;0
32135   FOR i=0 TO n_info:CURSOR #ch;3,2+i*10:PRINT #ch;info$(i)
32140   CLOSE#ch
32145   REPeat loop:RD_PTR addr,it%,sw%,ev%,xr%,yr%,blflg%(TO n_it):IF sw%=-1 AND it%<>-1 THEN EXIT loop
32150   DR_UNST addr:RECHP addr:RECHP ptr(0):RECHP ptr(1)
32155   RETurn it%
32160 END DEFine 
32165 REMark -----------------------------------------------------------------
32170 DEFine FuNction BX_INPUT$(info$,item$,pointer)
32175   LOCal blflg%(8),i,loop,wdt,n_it,n_info,i_cnt,ptr(2)
32180   LOCal addr,it%,sw%,ev%,xr%,yr%,ch
32185   n_info=DIMN(info$):l_sk$=""
32190   wdt=0:FOR i=0 TO n_info:IF wdt<LEN(info$(i)) THEN wdt=LEN(info$(i))
32195   ixs=wdt*6
32200   n_it=-1:str_p=0
32205   set_loose n_it;ixs-4,10,6,n_info*10+22;item$(1),256,item$,0:l_jus%(n_it,0)=1:l_jus%(n_it,1)=0
32210   set_loose n_it;ixs-4,10,6,n_info*10+22;item$(1),256,item$,0:l_jus%(n_it,0)=1:l_jus%(n_it,1)=0
32215   ptr(0)=MK_LIL(attr,l_size%(TO n_it),l_org%(TO n_it),l_jus%(TO n_it),l_sk$,l_type%(TO n_it),l_strg$(TO n_it),l_pblb(TO n_it),l_ppat(TO n_it))
32220   set_arr3 iwattr%(0);0,1,4,7
32225   set_arr3 iwattr%(1);0,1,4,7
32230   set_arr3 iwdef%(0);(wdt+2)*6,n_info*12+12,4,2
32235   set_arr3 iwdef%(1);(wdt+2)*6,12,4,n_info*12+17
32240   ptr(1)=MK_IWL(iwdef%(TO 1),iwattr%(TO 1),l_pblb(TO 1))
32245   set_arr3 wattr%;1,1,4,7
32250   set_arr3 wdef%;(wdt+2)*6+8,(n_info+4)*10-4,20,20
32255   addr=MK_WDEF(wdef%,wattr%,pointer,ptr(0),ptr(1),0)
32260   DR_PULD addr,-1,-1,blflg%(TO n_it)
32265   ch=FOPEN('con'):DR_IWDF #ch;addr,0:STRIP #ch;7:INK #ch;0
32270   FOR i=0 TO n_info:CURSOR #ch;3,2+i*10:PRINT #ch;info$(i)
32275   DR_LWDF #ch;addr,0:PAPER#ch,wattr%(3):INK #ch;0:CLS #ch:INPUT #ch;item$
32280   CLOSE#ch
32285   DR_UNST addr:RECHP addr:RECHP ptr(0):RECHP ptr(1)
32290   RETurn item$
32295 END DEFine 
32300 REMark -----------------------------------------------------------------
32305 DEFine PROCedure set_loose(nr,xs,ys,xp,yp,k$,type,str$,adr)
32310   nr=nr+1
32315   l_size%(nr,0)=xs:l_size%(nr,1)=ys
32320   l_org%(nr,0)=xp:l_org%(nr,1)=yp
32325   l_sk$=l_sk$&k$
32330   l_type%(nr)=type
32335   IF (type&&255)=0 THEN 
32340      l_strg$(str_p)=str$:str_p=str_p+1
32345   ELSE 
32350      l_pspr(spr_p)=adr:spr_p=spr_p+1
32355   END IF 
32360 END DEFine set_loose
32365 : REMark -----------------------------------------------------------
32370 DEFine PROCedure set_arr3(feld,c1,c2,c3,c4)
32375   feld(0)=c1:feld(1)=c2:feld(2)=c3:feld(3)=c4
32380 END DEFine 
32385 : REMark -------------------------------------------------------------
32390 DEFine FuNction make_button(area,but$)
32395   LOCal xs,n_it,ptr
32400   xs=6*LEN(but$)+6:xs=xs&&-8
32405   n_it=-1 : l_sk$="" : str_p=0
32410   set_loose n_it;xs,10,2,1;CHR$(0);256,but$,0:l_jus%(n_it,0)=0:l_jus%(n_it,1)=0
32415   set_loose n_it;xs,10,2,1;CHR$(2);256,but$,0:l_jus%(n_it,0)=0:l_jus%(n_it,1)=0
32420   ptr=MK_LIL(attr,l_size%(TO n_it),l_org%(TO n_it),l_jus%(TO n_it),l_sk$,l_type%(TO n_it),l_strg$(TO n_it),l_pblb(TO n_it),l_ppat(TO n_it))
32425   set_arr3 wdef%;xs+4,12,0,0
32430   POKE_W area+92,xs+8:POKE_W area+94,12
32435   set_arr3 wattr%;0,1,4,7
32440   RETurn MK_WDEF(wdef%,wattr%,0,ptr,0,0)
32445 END DEFine 
32450 REMark ------------------------------------------------------------------
32455 DEFine PROCedure rd_button(ch,area)
32460   LOCal prior,xp,yp,loop,clflg%(1),it%,sw%,ev%,xr%,yr%
32465   prior=PJOB(-1)
32470   POKE_L area+256,PEEK_L(area+92)
32475   ALBUT area+256:IF PEEK_L(area+256)=-1 THEN xp=-1:yp=-1:ELSE xp=PEEK_W(area+256)+2:yp=PEEK_W(area+258)+2
32480   DR_UNST PEEK_L(area+80):CLOSE#ch
32482   OPEN #ch;'con_2x1a0x0'
32485   IF JOB$(-1)="" THEN 
32490      DR_PULD PEEK_L(area+76),xp,yp,clflg%
32495   ELSE 
32500      DR_PPOS #ch;PEEK_L(area+76),xp,yp,clflg%
32505   END IF 
32510   SPJOB -1,1
32515   REPeat loop
32520      RD_PTR PEEK_L(area+76),it%,sw%,ev%,xr%,yr%,clflg%
32525      IF sw%=-1 AND it%<>-1 AND xp+yp=-2 THEN CH_WIN PEEK_L(area+76)
32530      IF sw%=-1 AND ev%=1 THEN EXIT loop
32535   END REPeat loop
32540   SPJOB -1,prior
32545   DR_UNST PEEK_L(area+76):CLOSE #ch
32547   OPEN #ch,'con_2x1a0x0'
32550   REBUT
32555   DR_APP #ch,area
32560 END DEFine 
32570 REMark ----------------------------------------------------------------------
32580 DEFine PROCedure DR_CHAN(ch,area)
32585    CURDIS #ch
32590    DR_AWDF #ch;PEEK_L(area+80),0:PAPER #ch;attr(2,0):INK #ch;attr(2,1)
32595    OVER #ch,0
32600 END DEFine 
32610 REMark ---------------------------------------------------------------------
32720 REMark          Application Manager v1.00 written by O.Fink
32730 REMark ---------------------------------------------------------------------
