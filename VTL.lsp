; VTL - Ve ky hieu taluy tren binh do, AutoCAD 2022.
; Don vi nhap mm/cm/m duoc doi theo INSUNITS cua ban ve.
; Moi taluy sinh mot INSERT; khong thay doi cac duong mep da chon.
; Hai vach cung mau theo layer goc; hai o mau cu chi giu de tuong thich CFG.
; r6 (02/10/2026): mep dich la LINE khong con mat doan cuoi / cham; nhan so co dau
;   phay (1,5); 2 mep: kich hut thi hoi lai, khong thoat lenh; so hien gon;
;   INSUNITS = 0 thi bao ro don vi nhap khong doi.
; r7 (15/10/2026): them trien khai trac ngang (ADS Civil) thanh mat bang XYZ:
;   thiet ke hoac khao sat; polyline ngang + noi doc, ghi cao do, do doc,
;   ky hieu taluy/giat co. Xem phan TNMB o cuoi file.
; r8 (15/10/2026): gop chung 1 hop thoai lenh VTL (chon chuc nang o dau hop thoai;
;   TNMB van go duoc); khong gioi han so trac ngang (ghep doi tuong bang quet truc Y);
;   moi phan ket qua 1 layer rieng, chon mau tung layer.

(vl-load-com)
(setq *VTL:BUILD* "2026-10-15-r8")

; Doi cau hinh cu: ty le vach ngan -> chieu dai vach ngan cung don vi nhap.
(if (not (equal *VTL:CFG-SCHEMA* 2))
  (progn
    (if (and *VTL:CFG* (= (length *VTL:CFG*) 11))
      (setq *VTL:CFG*
        (list (nth 0 *VTL:CFG*) (nth 1 *VTL:CFG*) (nth 2 *VTL:CFG*)
              (nth 3 *VTL:CFG*) (nth 4 *VTL:CFG*) (nth 5 *VTL:CFG*)
              (nth 6 *VTL:CFG*)
              (rtos (* (atof (nth 6 *VTL:CFG*))
                       (atof (nth 7 *VTL:CFG*))) 2 8)
              (nth 8 *VTL:CFG*) (nth 9 *VTL:CFG*) (nth 10 *VTL:CFG*)))
      (setq *VTL:CFG*
        '("0" "0" "VTL-DAP" "256" "256" "1.0" "3.0" "1.05" "2" "1" "3")))
    (setq *VTL:CFG-SCHEMA* 2)))

(defun VTL:write-dcl (path / file row ok)
  (setq ok nil file (open path "w"))
  (if file
    (progn
      (foreach row
        (list
          "vtl_dialog : dialog {"
          " label = \"VTL - Taluy b\\U+00ECnh \\U+0111\\U+1ED3 & Tri\\U+1EC3n khai tr\\U+1EAFc ngang th\\U+00E0nh m\\U+1EB7t b\\U+1EB1ng\";"
          " : column {"
          "  : boxed_radio_row { label = \"Ch\\U+1EE9c n\\U+0103ng\";"
          "   : radio_button { key = \"f_taluy\"; label = \"V\\U+1EBD k\\U+00FD hi\\U+1EC7u taluy tr\\U+00EAn b\\U+00ECnh \\U+0111\\U+1ED3\"; }"
          "   : radio_button { key = \"f_tnmb\"; label = \"Tri\\U+1EC3n khai tr\\U+1EAFc ngang th\\U+00E0nh m\\U+1EB7t b\\U+1EB1ng\"; }"
          "  }"
          "  : row {"
          "   : column {"
          "    : boxed_row { label = \"Ki\\U+1EC3u taluy v\\U+00E0 c\\U+00E1ch ch\\U+1ECDn m\\U+00E9p\";"
          "     : radio_column {"
          "      : radio_button { key = \"dap\"; label = \"Taluy \\U+0111\\U+1EAFp\"; }"
          "      : radio_button { key = \"dao\"; label = \"Taluy \\U+0111\\U+00E0o\"; }"
          "     }"
          "     : radio_column {"
          "      : radio_button { key = \"mot\"; label = \"M\\U+1ED9t m\\U+00E9p: nh\\U+1EADp r\\U+1ED9ng m\\U+00E1i\"; }"
          "      : radio_button { key = \"hai\"; label = \"Hai m\\U+00E9p: v\\U+1EA1ch d\\U+00E0i ch\\U+1EA1m m\\U+00E9p th\\U+1EE9 hai\"; }"
          "     }"
          "    }"
          "    : boxed_column { label = \"L\\U+1EDBp v\\U+1EBD\";"
          "     : edit_box { key = \"layer\"; label = \"T\\U+00EAn l\\U+1EDBp g\\U+1ED1c\"; edit_width = 20; }"
          "     : text { label = \"M\\U+00E0u c\\U+1EE7a t\\U+1EA5t c\\U+1EA3 v\\U+1EA1ch theo l\\U+1EDBp n\\U+00E0y.\"; }"
          "    }"
          "    : boxed_column { label = \"K\\U+00EDch th\\U+01B0\\U+1EDBc v\\U+1EA1ch\";"
          "     : popup_list { key = \"unit\"; label = \"\\U+0110\\U+01A1n v\\U+1ECB s\\U+1ED1 nh\\U+1EADp\"; width = 17; }"
          "     : edit_box { key = \"buoc\"; label = \"Kho\\U+1EA3ng c\\U+00E1ch gi\\U+1EEFa 2 v\\U+1EA1ch\"; edit_width = 9; }"
          "     : row {"
          "      : edit_box { key = \"rong\"; label = \"Chi\\U+1EC1u d\\U+00E0i v\\U+1EA1ch d\\U+00E0i\"; edit_width = 9; }"
          "      : edit_box { key = \"ngan\"; label = \"Chi\\U+1EC1u d\\U+00E0i v\\U+1EA1ch ng\\U+1EAFn\"; edit_width = 9; }"
          "     }"
          "     : text { label = \"Khi ch\\U+1ECDn 2 m\\U+00E9p, v\\U+1EA1ch d\\U+00E0i t\\U+1EDBi m\\U+00E9p th\\U+1EE9 hai.\"; }"
          "     : text { label = \"V\\U+1EA1ch ng\\U+1EAFn nh\\U+1EADp chi\\U+1EC1u d\\U+00E0i th\\U+1EF1c, kh\\U+00F4ng v\\U+01B0\\U+1EE3t m\\U+00E9p \\U+0111\\U+00EDch.\"; }"
          "    }"
          "    : boxed_row { label = \"Chu k\\U+1EF3 v\\U+1EA1ch (l\\U+1EB7p su\\U+1ED1t tuy\\U+1EBFn)\";"
          "     : edit_box { key = \"sodai\"; label = \"S\\U+1ED1 v\\U+1EA1ch d\\U+00E0i\"; edit_width = 6; }"
          "     : edit_box { key = \"songan\"; label = \"S\\U+1ED1 v\\U+1EA1ch ng\\U+1EAFn\"; edit_width = 6; }"
          "    }"
          "    : text { label = \"V\\U+00ED d\\U+1EE5: 1 d\\U+00E0i + 3 ng\\U+1EAFn; ho\\U+1EB7c 2 d\\U+00E0i + 5 ng\\U+1EAFn.\"; }"
          "    spacer_1;"
          "   }"
          "   : column {"
          "    : row {"
          "     : boxed_radio_column { label = \"Lo\\U+1EA1i tr\\U+1EAFc ngang\";"
          "      : radio_button { key = \"m_tk\"; label = \"Thi\\U+1EBFt k\\U+1EBF\"; }"
          "      : radio_button { key = \"m_ks\"; label = \"Kh\\U+1EA3o s\\U+00E1t (t\\U+1EF1 nhi\\U+00EAn)\"; }"
          "     }"
          "     : boxed_radio_column { label = \"\\U+0110\\U+1ECBnh v\\U+1ECB m\\U+1EB7t b\\U+1EB1ng\";"
          "      : radio_button { key = \"m_that\"; label = \"T\\U+1ECDa \\U+0111\\U+1ED9 th\\U+1EADt VN-2000 (ch\\U+1ECDn tim tuy\\U+1EBFn)\"; }"
          "      : radio_button { key = \"m_thang\"; label = \"Du\\U+1ED7i th\\U+1EB3ng t\\U+1EA1i \\U+0111i\\U+1EC3m pick\"; }"
          "     }"
          "    }"
          "    : boxed_column { label = \"Nh\\U+1EADn d\\U+1EA1ng l\\U+1EDBp tr\\U+1EAFc ngang (wildcard, c\\U+00E1ch nhau d\\U+1EA5u ph\\U+1EA9y)\";"
          "     : edit_box { key = \"m_lbang\"; label = \"B\\U+1EA3ng tr\\U+1EAFc ngang (\\U+0111\\U+01B0\\U+1EDDng tim)\"; edit_width = 26; }"
          "     : edit_box { key = \"m_lly\"; label = \"Ch\\U+1EEF l\\U+00FD tr\\U+00ECnh\"; edit_width = 26; }"
          "     : edit_box { key = \"m_ltk\"; label = \"L\\U+1EDBp thi\\U+1EBFt k\\U+1EBF\"; edit_width = 26; }"
          "     : edit_box { key = \"m_lks\"; label = \"L\\U+1EDBp kh\\U+1EA3o s\\U+00E1t\"; edit_width = 26; }"
          "     : edit_box { key = \"m_ltaluy\"; label = \"L\\U+1EDBp taluy (k\\U+00FD hi\\U+1EC7u)\"; edit_width = 26; }"
          "    }"
          "    : boxed_column { label = \"K\\U+1EBFt qu\\U+1EA3\";"
          "     : row {"
          "      : edit_box { key = \"m_font\"; label = \"Font ch\\U+1EEF\"; edit_width = 12; }"
          "      : edit_box { key = \"m_hchu\"; label = \"Cao ch\\U+1EEF (mm)\"; edit_width = 6; }"
          "     }"
          "     : row {"
          "      : edit_box { key = \"m_width\"; label = \"Global Width (mm)\"; edit_width = 6; }"
          "      : edit_box { key = \"m_tyle\"; label = \"T\\U+1EF7 l\\U+1EC7 1/\"; edit_width = 6; }"
          "     }"
          "     : radio_row {"
          "      : radio_button { key = \"m_k3d\"; label = \"Polyline 3D (Z th\\U+1EADt)\"; }"
          "      : radio_button { key = \"m_klw\"; label = \"LWPolyline c\\U+00F3 Global Width\"; }"
          "     }"
          "    }"
          "    : boxed_column { label = \"Hi\\U+1EC3n th\\U+1ECB (ch\\U+1ECDn nh\\U+1EEFng g\\U+00EC c\\U+1EA7n v\\U+1EBD)\";"
          "     : row {"
          "      : toggle { key = \"m_caodo\"; label = \"Cao \\U+0111\\U+1ED9\"; }"
          "      : toggle { key = \"m_dodoc\"; label = \"\\U+0110\\U+1ED9 d\\U+1ED1c\"; }"
          "      : toggle { key = \"m_tencoc\"; label = \"T\\U+00EAn c\\U+1ECDc\"; }"
          "      : toggle { key = \"m_doc\"; label = \"N\\U+1ED1i d\\U+1ECDc\"; }"
          "     }"
          "     : row {"
          "      : toggle { key = \"m_kyhieu\"; label = \"K\\U+00FD hi\\U+1EC7u taluy (thi\\U+1EBFt k\\U+1EBF)\"; }"
          "      : edit_box { key = \"m_buoc\"; label = \"B\\U+01B0\\U+1EDBc v\\U+1EA1ch (m)\"; edit_width = 6; }"
          "     }"
          "    }"
          "    : boxed_column { label = \"Layer ri\\U+00EAng t\\U+1EEBng ph\\U+1EA7n: ti\\U+1EC1n t\\U+1ED1 + h\\U+1EADu t\\U+1ED1 (b\\U+1EA5m \\U+00F4 m\\U+00E0u \\U+0111\\U+1EC3 \\U+0111\\U+1ED5i m\\U+00E0u layer)\";"
          "     : edit_box { key = \"m_prefix\"; label = \"Ti\\U+1EC1n t\\U+1ED1 layer\"; edit_width = 26; }"
          "     : row {"
          "      : column {"
          "       : row { : text { label = \"Polyline ngang  -NGANG\"; width = 24; fixed_width = true; } : image_button { key = \"c_ngang\"; width = 5; height = 1; fixed_width = true; fixed_height = true; } : text { key = \"t_ngang\"; width = 5; fixed_width = true; } }"
          "       : row { : text { label = \"Polyline d\\U+1ECDc  -DOC\"; width = 24; fixed_width = true; } : image_button { key = \"c_doc\"; width = 5; height = 1; fixed_width = true; fixed_height = true; } : text { key = \"t_doc\"; width = 5; fixed_width = true; } }"
          "       : row { : text { label = \"Ch\\U+1EEF cao \\U+0111\\U+1ED9  -CAODO\"; width = 24; fixed_width = true; } : image_button { key = \"c_caodo\"; width = 5; height = 1; fixed_width = true; fixed_height = true; } : text { key = \"t_caodo\"; width = 5; fixed_width = true; } }"
          "      }"
          "      : column {"
          "       : row { : text { label = \"Ch\\U+1EEF \\U+0111\\U+1ED9 d\\U+1ED1c  -DODOC\"; width = 24; fixed_width = true; } : image_button { key = \"c_dodoc\"; width = 5; height = 1; fixed_width = true; fixed_height = true; } : text { key = \"t_dodoc\"; width = 5; fixed_width = true; } }"
          "       : row { : text { label = \"V\\U+1EA1ch taluy  -VACHTALUY\"; width = 24; fixed_width = true; } : image_button { key = \"c_vach\"; width = 5; height = 1; fixed_width = true; fixed_height = true; } : text { key = \"t_vach\"; width = 5; fixed_width = true; } }"
          "       : row { : text { label = \"T\\U+00EAn c\\U+1ECDc  -TENCOC\"; width = 24; fixed_width = true; } : image_button { key = \"c_ten\"; width = 5; height = 1; fixed_width = true; fixed_height = true; } : text { key = \"t_ten\"; width = 5; fixed_width = true; } }"
          "      }"
          "     }"
          "     : toggle { key = \"m_maugoc\"; label = \"Polyline ngang/d\\U+1ECDc l\\U+1EA5y m\\U+00E0u theo l\\U+1EDBp g\\U+1ED1c (m\\U+1EB7t \\U+0111\\U+01B0\\U+1EDDng, l\\U+1EC1, taluy... m\\U+1ED7i lo\\U+1EA1i m\\U+1ED9t m\\U+00E0u)\"; }"
          "    }"
          "    : text { label = \"Kh\\U+00F4ng gi\\U+1EDBi h\\U+1EA1n s\\U+1ED1 tr\\U+1EAFc ngang. Taluy, gi\\U+1EADt c\\U+01A1, \\U+0111\\U+1ED9 d\\U+1ED1c l\\U+1EA5y theo l\\U+1EDBp thi\\U+1EBFt k\\U+1EBF.\"; }"
          "   }"
          "  }"
          "  ok_cancel;"
          " }"
          "}"
        )
        (write-line row file))
      (close file)
      (setq ok t)))
  ok)

; Chuoi -> so. Nhan dau phay thap phan kieu Viet: distof cua AutoCAD tra nil voi
; "1,5" nen truoc day anh go 1,5 bi bao "phai lon hon 0" (khong nhan so).
(defun VTL:to-number (s / n)
  (setq s (vl-string-translate "," "." (vl-string-trim " " s)))
  (if (/= s "")
    (progn (setq n (distof s 2)) (if (numberp n) n))))

(defun VTL:number (key) (VTL:to-number (get_tile key)))

; So -> chuoi gon (3 thay vi 3.00000000), khong phu thuoc DIMZIN.
(defun VTL:str (n / s)
  (setq s (rtos n 2 8))
  (if (vl-string-search "." s)
    (vl-string-right-trim "." (vl-string-right-trim "0" s))
    s))

(defun VTL:positive-integer (n)
  (and (numberp n) (>= n 0.0) (= n (float (fix n)))))

; Doi kieu dap/dao: lop dang la ten mac dinh thi doi theo kieu.
(defun VTL:set-type (kind / current)
  (setq current (get_tile "layer"))
  (if (member current '("VTL-DAP" "VTL-DAO"))
    (set_tile "layer" (strcat "VTL-" kind)))
  (VTL:refresh))

; Bat/tat o nhap: chi nhom cua chuc nang dang chon duoc sua.
(defun VTL:refresh (/ ta tn tk k)
  (setq ta (= (get_tile "f_taluy") "1") tn (not ta)
        tk (= (get_tile "m_tk") "1"))
  ; Ve ky hieu taluy tren binh do
  (foreach k '("dap" "dao" "mot" "hai" "layer" "unit" "buoc" "ngan" "sodai" "songan")
    (mode_tile k (if ta 0 1)))
  ; Hai mep: vach dai cham mep dich nen o chieu dai vach dai khong dung.
  (mode_tile "rong" (if (and ta (= (get_tile "mot") "1")) 0 1))
  ; Trien khai trac ngang
  (foreach k '("m_tk" "m_ks" "m_that" "m_thang" "m_lbang" "m_lly" "m_ltk" "m_lks"
               "m_prefix" "m_font" "m_hchu" "m_tyle" "m_k3d" "m_klw" "m_maugoc"
               "m_caodo" "m_dodoc" "m_tencoc" "m_doc"
               "c_ngang" "c_doc" "c_caodo" "c_dodoc" "c_ten")
    (mode_tile k (if tn 0 1)))
  (mode_tile "m_width" (if (and tn (= (get_tile "m_klw") "1")) 0 1))
  ; Ky hieu taluy chi co o trac ngang thiet ke.
  (foreach k '("m_kyhieu" "m_ltaluy" "c_vach")
    (mode_tile k (if (and tn tk) 0 1)))
  (mode_tile "m_buoc" (if (and tn tk (= (get_tile "m_kyhieu") "1")) 0 1)))

; Kiem tra va luu thiet lap ve taluy. Tra T neu hop le.
(defun VTL:accept-taluy (/ layer step width shortlen nl ns msg)
  (setq layer (vl-string-trim " " (get_tile "layer"))
        step (VTL:number "buoc") width (VTL:number "rong")
        shortlen (VTL:number "ngan")
        nl (VTL:number "sodai") ns (VTL:number "songan")
        msg nil)
  (cond
    ((or (= layer "") (not (snvalid layer)))
     (setq msg "Ten lop khong hop le."))
    ((not (and (numberp step) (> step 0.0)))
     (setq msg "Khoang cach vach phai lon hon 0."))
    ((and (= (get_tile "mot") "1")
          (not (and (numberp width) (> width 0.0))))
     (setq msg "Mot mep: chieu dai vach dai phai lon hon 0."))
    ((not (and (numberp shortlen) (> shortlen 0.0)))
     (setq msg "Chieu dai vach ngan phai lon hon 0."))
    ((not (and (VTL:positive-integer nl) (VTL:positive-integer ns)
               (> (+ nl ns) 0)))
     (setq msg "So vach dai/ngan phai la so nguyen khong am; tong > 0.")))
  (if msg
    (progn (alert msg) nil)
    (progn
      (setq *VTL:PENDING*
        (list (if (= (get_tile "dao") "1") "1" "0")
              (if (= (get_tile "hai") "1") "1" "0")
              ; Hai gia tri 256 la cot CFG cu, khong con la lua chon mau.
              layer "256" "256"
              (VTL:str step)
              (VTL:str (if (and (numberp width) (> width 0.0)) width 1.0))
              (VTL:str shortlen)
              (get_tile "unit") (itoa (fix nl)) (itoa (fix ns))))
      T)))

; OK: kiem tra theo chuc nang dang chon.
(defun VTL:accept (/ tn)
  (setq tn (= (get_tile "f_tnmb") "1"))
  (if (if tn (TNMB:accept) (VTL:accept-taluy))
    (progn
      (setq *VTL:FN-PENDING* (if tn "TNMB" "TALUY"))
      (done_dialog 1))))

; Hop thoai chung. Tra "TALUY" / "TNMB" theo chuc nang chon, nil neu huy.
(defun VTL:dialog (/ path dcl status k)
  (setq path (vl-filename-mktemp "VTL" nil ".dcl"))
  (cond
    ((not (VTL:write-dcl path)) (alert "Khong ghi duoc hop thoai VTL."))
    ((<= (setq dcl (load_dialog path)) 0) (alert "Khong nap duoc hop thoai VTL."))
    ((not (new_dialog "vtl_dialog" dcl)) (alert "Khong mo duoc hop thoai VTL."))
    (T
      ; Nhom ve taluy tren binh do
      (start_list "unit")
      (mapcar 'add_list '("mm" "cm" "m"))
      (end_list)
      (mapcar
        '(lambda (p) (set_tile (car p) (cadr p)))
        (mapcar 'list
          '("layer" "buoc" "rong" "ngan" "unit" "sodai" "songan")
          (list (nth 2 *VTL:CFG*) (nth 5 *VTL:CFG*)
                (nth 6 *VTL:CFG*) (nth 7 *VTL:CFG*)
                (nth 8 *VTL:CFG*) (nth 9 *VTL:CFG*)
                (nth 10 *VTL:CFG*))))
      (set_tile (if (= (car *VTL:CFG*) "1") "dao" "dap") "1")
      (set_tile (if (= (cadr *VTL:CFG*) "1") "hai" "mot") "1")
      ; Nhom trien khai trac ngang
      (TNMB:init-tiles)
      ; Chuc nang lan truoc
      (set_tile (if (= *VTL:FN* "TNMB") "f_tnmb" "f_taluy") "1")
      (VTL:refresh)
      (foreach k '("f_taluy" "f_tnmb" "mot" "hai" "m_k3d" "m_klw" "m_kyhieu")
        (action_tile k "(VTL:refresh)"))
      (action_tile "dao" "(VTL:set-type \"DAO\")")
      (action_tile "dap" "(VTL:set-type \"DAP\")")
      (action_tile "m_tk" "(TNMB:set-type T)")
      (action_tile "m_ks" "(TNMB:set-type nil)")
      (foreach k (mapcar 'car *TNMB:PARTS*)
        (action_tile k "(TNMB:pick-color $key)"))
      (action_tile "accept" "(VTL:accept)")
      (setq status (start_dialog))
      (if (= status 1)
        (progn
          (setq *VTL:FN* *VTL:FN-PENDING*)
          (if (= *VTL:FN* "TNMB")
            (setq *TNMB:CFG* *TNMB:PENDING*)
            (setq *VTL:CFG* *VTL:PENDING*))))))
  (if (and dcl (> dcl 0)) (unload_dialog dcl))
  (if (and path (findfile path)) (vl-file-delete path))
  (if (= status 1) *VTL:FN*))

; Hinh hoc trong mat phang WCS XY. Ham tra so huu ti de tranh bo qua mep cong.
(defun VTL:xy (p) (list (car p) (cadr p)))
(defun VTL:sub (a b) (list (- (car a) (car b)) (- (cadr a) (cadr b))))
(defun VTL:cross (a b) (- (* (car a) (cadr b)) (* (cadr a) (car b))))
(defun VTL:dot (a b) (+ (* (car a) (car b)) (* (cadr a) (cadr b))))
(defun VTL:length (a) (sqrt (VTL:dot a a)))
(defun VTL:unit (a / d)
  (setq d (VTL:length a))
  (if (> d 1e-12) (list (/ (car a) d) (/ (cadr a) d))))
(defun VTL:plus (a b scale)
  (list (+ (car a) (* scale (car b))) (+ (cadr a) (* scale (cadr b)))))
(defun VTL:side (base dir p)
  (VTL:cross dir (VTL:sub p base)))

(defun VTL:curve-object (curve)
  (if (= (type curve) 'ENAME) (vlax-ename->vla-object curve) curve))

(defun VTL:curve-ok (en / ed ty flag)
  (setq ed (entget en) ty (cdr (assoc 0 ed)))
  (cond
    ((= ty "LINE") t)
    ((= ty "LWPOLYLINE") t)
    ((= ty "POLYLINE")
     (setq flag (cdr (assoc 70 ed)))
     (= 0 (logand flag 88)))
    (t nil)))

(defun VTL:point (en d total)
  (if (>= d (- total 1e-9))
    (vlax-curve-getEndPoint en)
    (vlax-curve-getPointAtDist en d)))

(defun VTL:tangent (en d total step / eps a b)
  (setq eps (min (* step 0.02) (* total 0.01)))
  (if (< eps 1e-8) (setq eps (* total 0.1)))
  (setq a (VTL:point en (max 0.0 (- d eps)) total)
        b (VTL:point en (min total (+ d eps)) total))
  (if (and a b) (VTL:unit (VTL:sub b a))))

; Moc tham so de chia mep dich. LINE: tham so chay tu 0 toi CHIEU DAI (khong phai
; 0..1) -> chi 1 doan. Truoc day chia theo so nguyen: LINE dai 10.5 mat 0.5 cuoi,
; LINE ngan hon 1 khong con doan nao, LINE 20000 mm thanh 20000 doan (rat cham).
; Polyline: moi dinh 1 moc, them tham so cuoi neu le.
(defun VTL:breaks (en / s e k r)
  (setq s (vlax-curve-getStartParam en) e (vlax-curve-getEndParam en))
  (if (= (vla-get-ObjectName en) "AcDbLine")
    (list s e)
    (progn
      (setq r (list s) k (1+ (fix s)))
      (while (< k (- e 1e-9)) (setq r (cons (float k) r) k (1+ k)))
      (reverse (cons e r)))))

; Noi cac canh dich thanh doan. Doan cung duoc chia nho theo buoc vach.
(defun VTL:segments (en step / ks k k1 a b mid chord seglen n j prev curr result)
  (setq ks (VTL:breaks en) result nil)
  (while (cdr ks)
    (setq k (car ks) k1 (cadr ks) ks (cdr ks))
    (setq a (vlax-curve-getPointAtParam en k)
          b (vlax-curve-getPointAtParam en k1)
          mid (vlax-curve-getPointAtParam en (* 0.5 (+ k k1)))
          seglen (- (vlax-curve-getDistAtParam en k1)
                    (vlax-curve-getDistAtParam en k)))
    (if (and a b mid (> seglen 1e-9))
      (progn
        (setq chord (VTL:sub b a)
              n (if (< (abs (VTL:cross chord (VTL:sub mid a)))
                       (* 1e-7 seglen seglen))
                  1
                  (min 2048 (max 4 (fix (+ 0.999999 (/ seglen (* step 0.25)))))))
              j 1 prev a)
        (repeat n
          (setq curr (vlax-curve-getPointAtParam en (+ k (* (- k1 k) (/ (float j) n)))))
          (if (and curr (> (distance (VTL:xy prev) (VTL:xy curr)) 1e-9))
            (setq result (cons (list (VTL:xy prev) (VTL:xy curr)) result)))
          (setq prev curr j (1+ j))))))
  (reverse result))

; Tim giao gan nhat cua tia p + t*dir (t>0) voi cac doan mep dich.
(defun VTL:ray-hit (p dir segs / s a b edge den ap tval uval best)
  (setq best nil)
  (foreach s segs
    (setq a (car s) b (cadr s) edge (VTL:sub b a)
          den (VTL:cross dir edge))
    (if (> (abs den) 1e-12)
      (progn
        (setq ap (VTL:sub a p)
              tval (/ (VTL:cross ap edge) den)
              uval (/ (VTL:cross ap dir) den))
        (if (and (> tval 1e-8) (>= uval -1e-8) (<= uval (+ 1.0 1e-8))
                 (or (null best) (< tval best)))
          (setq best tval)))))
  best)

(defun VTL:layer (name color / layers result setcolor)
  (if (tblsearch "LAYER" name)
    name
    (progn
      ; Tao lop bang Layers collection cua AutoCAD.
      (setq layers (vla-get-Layers (vla-get-ActiveDocument (vlax-get-acad-object)))
            result (vl-catch-all-apply 'vla-Add (list layers name)))
      (if (vl-catch-all-error-p result)
        (progn
          (princ (strcat "\nKhong tao duoc layer " name ": "
                         (vl-catch-all-error-message result)))
          nil)
        (progn
          (setq setcolor (vl-catch-all-apply 'vla-put-Color (list result color)))
          (if (vl-catch-all-error-p setcolor)
            (progn
              (princ (strcat "\nKhong dat duoc mau layer " name ": "
                             (vl-catch-all-error-message setcolor)))
              nil)
            (if (tblsearch "LAYER" name) name
              (progn
                (princ (strcat "\nDa them layer nhung khong tim thay trong bang lop: " name))
                nil))))))))

(defun VTL:local-point (p base / z bz)
  (setq z (if (caddr p) (caddr p) 0.0)
        bz (if (caddr base) (caddr base) 0.0))
  (list (- (car p) (car base))
        (- (cadr p) (cadr base))
        (- z bz)))

(defun VTL:line (p q layer color base)
  (entmake (list '(0 . "LINE") (cons 8 layer) (cons 62 color)
                 (cons 10 (VTL:local-point p base))
                 (cons 11 (VTL:local-point
                            (list (car q) (cadr q) (if (caddr p) (caddr p) 0.0))
                            base)))))

(defun VTL:block-name (/ name)
  (if (null *VTL:BLOCK-ID*) (setq *VTL:BLOCK-ID* 0))
  (setq *VTL:BLOCK-ID* (1+ *VTL:BLOCK-ID*)
        name (strcat "VTL_" (itoa *VTL:BLOCK-ID*)))
  (while (tblsearch "BLOCK" name)
    (setq *VTL:BLOCK-ID* (1+ *VTL:BLOCK-ID*)
          name (strcat "VTL_" (itoa *VTL:BLOCK-ID*))))
  name)

(defun VTL:delete-empty-block (name / blocks obj)
  (if (tblsearch "BLOCK" name)
    (progn
      (setq blocks (vla-get-Blocks (vla-get-ActiveDocument (vlax-get-acad-object)))
            obj (vl-catch-all-apply 'vla-Item (list blocks name)))
      (if (not (vl-catch-all-error-p obj))
        (vl-catch-all-apply 'vla-Delete (list obj))))))

; Moi taluy la mot INSERT. Cac LINE chi nam ben trong dinh nghia BLOCK.
(defun VTL:make-block (marks base-layer / name base start ok item finish inserted)
  (setq name (VTL:block-name)
        base (car (car marks))
        start (entmake (list '(0 . "BLOCK") '(8 . "0")
                             (cons 2 name) '(70 . 0)
                             '(10 0.0 0.0 0.0))))
  (if start
    (progn
      (setq ok t)
      (foreach item marks
        (if (not (VTL:line (nth 0 item) (nth 1 item)
                           (nth 2 item) (nth 3 item) base))
          (setq ok nil)))
      (setq finish (entmake '((0 . "ENDBLK") (8 . "0"))))
      (if (and ok finish)
        (progn
          (setq inserted
            (entmake (list '(0 . "INSERT") (cons 2 name)
                           (cons 8 base-layer)
                           (cons 10 (list (car base) (cadr base)
                                          (if (caddr base) (caddr base) 0.0)))
                           '(41 . 1.0) '(42 . 1.0) '(43 . 1.0) '(50 . 0.0))))
          (if inserted t
            (progn
              (VTL:delete-empty-block name)
              (princ "\nKhong chen duoc block taluy.")
              nil)))
        (progn
          (VTL:delete-empty-block name)
          (princ "\nKhong tao duoc day du dinh nghia block taluy.")
          nil)))
    (progn
      (princ "\nKhong tao duoc BLOCK taluy.")
      nil)))

; Ve vong theo chieu dai duong goc. Vach dai cham mep dich hoac rong nhap.
(defun VTL:draw (first second sidept cfg / total step width shortlen nl ns cy i d p tan normal
                         nearest nearstation neartan segments hit long color layer endpoint
                         drawn skipped errorcount sidesign closed marks use-length)
  (setq first (VTL:curve-object first)
        second (if second (VTL:curve-object second))
        total (vlax-curve-getDistAtParam first (vlax-curve-getEndParam first))
        step (atof (nth 5 cfg)) width (atof (nth 6 cfg))
        shortlen (atof (nth 7 cfg)) nl (atoi (nth 9 cfg)) ns (atoi (nth 10 cfg))
        cy (+ nl ns) i 0 drawn 0 skipped 0 errorcount 0 marks nil
        closed (vlax-curve-isClosed first)
        nearest (vlax-curve-getClosestPointTo first sidept)
        nearstation (if nearest (vlax-curve-getDistAtPoint first nearest))
        neartan (if nearstation (VTL:tangent first nearstation total step)))
  (if (and nearest neartan (> total 1e-9)
           (> (abs (VTL:side nearest neartan sidept)) 1e-9))
    (progn
      (setq sidesign (if (< (VTL:side nearest neartan sidept) 0.0) -1.0 1.0))
      (if second (setq segments (VTL:segments second step)))
      (setq d 0.0)
      (while (if closed
               (< d (- total (* step 1e-8)))
               (<= d (+ total (* step 1e-8))))
        (setq p (VTL:point first (min d total) total)
              tan (VTL:tangent first (min d total) total step))
        (if (and p tan)
          (progn
            (setq normal (list (* sidesign (- (cadr tan)))
                               (* sidesign (car tan))))
            (setq hit (if second (VTL:ray-hit p normal segments) width)
                  long (< (rem i cy) nl))
            (if hit
              (progn
                (setq use-length (if long hit (if second (min hit shortlen) shortlen))
                      color 256
                      layer (nth 2 cfg)
                      endpoint (VTL:plus p normal use-length)
                      marks (cons (list p endpoint layer color) marks)
                      drawn (1+ drawn)))
              (setq skipped (1+ skipped))))
          (setq skipped (1+ skipped)))
        (setq i (1+ i) d (* (float i) step))))
    (princ "\nKhong xac dinh duoc phia ve tai diem kich. Kich ro vao phia can ve, cach mep mot doan."))
  (if (> drawn 0)
    (if (not (VTL:make-block (reverse marks) (nth 2 cfg)))
      (setq errorcount (+ errorcount drawn) drawn 0)))
  (list drawn skipped errorcount))

(defun VTL:layer-visible (name / ed flag color)
  (setq ed (tblsearch "LAYER" name))
  (if (null ed)
    t
    (progn
      (setq flag (if (assoc 70 ed) (cdr (assoc 70 ed)) 0)
            color (if (assoc 62 ed) (cdr (assoc 62 ed)) 7))
      (if (and (= 0 (logand flag 5)) (> color 0))
        t
        (progn
          (princ (strcat "\nLayer " name " dang tat, dong bang hoac bi khoa; hay mo layer truoc."))
          nil)))))

(defun VTL:prepare-layers (cfg / base)
  (setq base (nth 2 cfg))
  (and (VTL:layer-visible base)
       (VTL:layer base 7)))

; INSUNITS=0: coi don vi chon la don vi CAD. 4/5/6: doi ve CAD.
(defun VTL:scaled-cfg (cfg / drawing input factor ins)
  (setq ins (getvar "INSUNITS")
        input (nth (atoi (nth 8 cfg)) '(0.001 0.01 1.0))
        drawing (cond ((= ins 4) 0.001) ((= ins 5) 0.01)
                      ((= ins 6) 1.0) ((= ins 0) input)))
  (if (null drawing)
    (progn (alert "INSUNITS cua ban ve khong phai mm/cm/m. Kiem tra don vi truoc khi ve.") nil)
    (progn
      (if (= ins 0)
        (princ (strcat "\n(!) Ban ve chua dat don vi (INSUNITS = 0): so nhap dung NGUYEN"
                       " la don vi ban ve, lua chon mm/cm/m KHONG doi gi.")))
      (setq factor (/ input drawing))
      (append (list (nth 0 cfg) (nth 1 cfg) (nth 2 cfg)
                    (nth 3 cfg) (nth 4 cfg)
                    (rtos (* factor (atof (nth 5 cfg))) 2 12)
                    (rtos (* factor (atof (nth 6 cfg))) 2 12)
                    (rtos (* factor (atof (nth 7 cfg))) 2 12))
              (list (nth 8 cfg) (nth 9 cfg) (nth 10 cfg))))))

(defun VTL:count-ok (en cfg / total n answer)
  (setq en (VTL:curve-object en)
        total (vlax-curve-getDistAtParam en (vlax-curve-getEndParam en))
        n (/ total (atof (nth 5 cfg))))
  (if (<= n 20000.0)
    t
    (progn
      (princ (strcat "\nDu kien " (rtos n 2 0)
                     " vach. So nay co the mat nhieu thoi gian."))
      (initget "Yes No")
      (setq answer (getkword "\nVan ve tiep? [Yes/No] <No>: "))
      (= answer "Yes"))))

; Kiem tra cung khong gian Model/Paper va mat phang ban ve.
(defun VTL:same-space (a b / da db)
  (setq da (entget a) db (entget b))
  (and (= (if (assoc 67 da) (cdr (assoc 67 da)) 0)
          (if (assoc 67 db) (cdr (assoc 67 db)) 0))
       (equal (if (assoc 410 da) (cdr (assoc 410 da)) "Model")
              (if (assoc 410 db) (cdr (assoc 410 db)) "Model"))))

; entsel tra nil CA khi Enter LAN khi kich hut. ERRNO 7 = kich hut -> hoi lai;
; truoc day kich hut la lenh ket thuc luon.
(defun VTL:pick (msg / r)
  (setvar "ERRNO" 0)
  (while (and (null (setq r (entsel msg))) (= 7 (getvar "ERRNO")))
    (princ "\nKhong trung doi tuong nao, kich lai.")
    (setvar "ERRNO" 0))
  r)

(defun C:VTL (/ *error* doc oldvars undo cfg mode ss first second pick i result
                 total skip failed blocks again item fn)
  (vl-load-com)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object))
        oldvars (mapcar '(lambda (x) (cons x (getvar x)))
                        '("OSMODE" "CMDECHO" "CLAYER" "ORTHOMODE"))
        undo nil)
  (defun *error* (msg)
    (if undo (progn (vla-EndUndoMark doc) (setq undo nil)))
    (foreach item oldvars (setvar (car item) (cdr item)))
    (if (and msg (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*EXIT*")))
      (princ (strcat "\nVTL loi: " msg)))
    (princ))
  ; Hop thoai chung: "TALUY" ve ky hieu taluy, "TNMB" trien khai trac ngang.
  (setq fn (VTL:dialog))
  ; Trien khai trac ngang tu luu/khoi phuc bien he thong va undo rieng.
  (if (= fn "TNMB") (TNMB:run))
  (if (= fn "TALUY")
    (progn
       (setq cfg (VTL:scaled-cfg *VTL:CFG*)
              mode (cadr *VTL:CFG*) total 0 skip 0 failed 0 blocks 0)
       (if cfg
         (progn
       (princ (strcat "\nVTL thiet lap: " (nth 9 cfg) " vach dai + " (nth 10 cfg)
                      " vach ngan; buoc " (VTL:str (atof (nth 5 cfg))) " don vi CAD; "
                      (if (= mode "0")
                        (strcat "dai " (VTL:str (atof (nth 6 cfg))) " don vi CAD")
                        "vach dai cham mep dich")
                      "; ngan " (VTL:str (atof (nth 7 cfg))) " don vi CAD."))
       (vla-StartUndoMark doc) (setq undo t)
       (setvar "OSMODE" 0)
       (if (VTL:prepare-layers cfg)
        (progn
          (if (= mode "0")
            (progn
              (princ "\nChon CAC duong mep taluy (LINE/POLYLINE), Enter de ket thuc:")
              (setq ss (ssget '((0 . "LINE,LWPOLYLINE,POLYLINE"))))
              (if ss
                (progn
                  (setq i 0)
                  (repeat (sslength ss)
                    (setq first (ssname ss i) i (1+ i))
                    (if (VTL:curve-ok first)
                      (progn
                        (setq pick (getpoint "\nKich diem PHIA muon dat taluy cho mep nay: "))
                        (if (and pick (VTL:count-ok first cfg))
                          (progn
                            (setq result (VTL:draw first nil (trans pick 1 0) cfg))
                            (setq total (+ total (car result))
                                  skip (+ skip (cadr result))
                                  failed (+ failed (caddr result)))
                            (if (> (car result) 0) (setq blocks (1+ blocks))))
                          (princ "\nBo qua mep nay.")))
                      (princ "\nBo qua doi tuong khong phai LINE/polyline 2D."))))))
            (progn
              (setq again t)
              (while again
                (setq item (VTL:pick "\nChon MEP BAT DAU (LINE/polyline), Enter de ket thuc: "))
                (if (null item)
                  (setq again nil)
                  (progn
                    (setq first (car item))
                    (setq item (VTL:pick "\nChon MEP DICH (LINE/polyline), Enter de bo cap nay: "))
                    (if (null item)
                      (princ "\nBo qua cap mep nay.")
                    (progn
                      (setq second (car item))
                      (if (and (not (eq first second))
                               (VTL:curve-ok first) (VTL:curve-ok second)
                               (VTL:same-space first second))
                        (progn
                          (setq pick (getpoint "\nKich phia co MEP DICH de chon huong vach: "))
                          (if (and pick (VTL:count-ok first cfg))
                            (progn
                              (setq result (VTL:draw first second (trans pick 1 0) cfg))
                              (setq total (+ total (car result))
                                    skip (+ skip (cadr result))
                                    failed (+ failed (caddr result)))
                              (if (> (car result) 0) (setq blocks (1+ blocks))))
                            (princ "\nBo qua cap mep nay.")))
                        (princ "\nHai mep phai khac nhau, cung khong gian va la LINE/polyline 2D.")))))))))
          (princ (strcat "\nVTL xong: " (itoa blocks) " block / " (itoa total) " vach; "
                         (itoa skip) " vi tri khong giao duoc mep dich; "
                         (itoa failed) " vach ve loi."))
          (if (> blocks 0) (redraw))
          (if (= total 0)
            (princ "\nKhong co vach nao: kiem tra thiet lap don vi, buoc vach va diem chi huong.")))
        (princ "\nVTL dung: layer chua san sang. Xem thong bao cu the o dong tren.")))
         (princ "\nVTL da dung do don vi ban ve khong hop le."))))
  (*error* nil))

;;; ======================================================================
;;; TNMB - TRIEN KHAI TRAC NGANG THANH MAT BANG (XYZ)
;;; (chuc nang thu 2 trong hop thoai lenh VTL; go TNMB cung mo hop thoai nay)
;;; Doc trac ngang ADS Civil (ty le ngang = dung = 1, don vi m):
;;;  - Tim mat cat : LINE dung tren lop bang (TK-ADS-9402*), chan tai mep tren bang.
;;;  - Ly trinh    : chu "Km a + b" (TK-ADS-9407*) phia tren duong tim.
;;;  - Muc so sanh : chu "MSS: x" o goc trai, ngang mep tren bang.
;;;  - Cao do      : Z = MSS + (y - y mep tren bang); khoang cach le = x - x tim.
;;; Ra mat bang   : P(ly trinh) tren tim tuyen; ben trai trac ngang = ben trai
;;;                 tuyen theo chieu ly trinh tang.
;;; Moi phan ket qua mot layer rieng: <tien to>-NGANG, -DOC, -CAODO, -DODOC,
;;; -VACHTALUY, -TENCOC; mau chon trong hop thoai la mau layer.
;;; ======================================================================

(setq *TNMB:LAYER-TK* "MB-TN-THIETKE" *TNMB:LAYER-KS* "MB-TN-KHAOSAT")

; Phan ket qua: (o mau, hau to layer, vi tri mau trong CFG, ten trong ngu canh).
(setq *TNMB:PARTS*
  '(("c_ngang" "-NGANG" 17 L-ngang) ("c_doc" "-DOC" 18 L-doc)
    ("c_caodo" "-CAODO" 19 L-caodo) ("c_dodoc" "-DODOC" 20 L-dodoc)
    ("c_vach" "-VACHTALUY" 21 L-vach) ("c_ten" "-TENCOC" 22 L-ten)))

; Cau hinh (chuoi): 0 loai TK/KS, 1 dinh vi THAT/THANG, 2 lop bang, 3 lop ly trinh,
; 4 lop thiet ke, 5 lop khao sat, 6 lop taluy, 7 tien to layer, 8 font, 9 cao chu mm,
; 10 width mm, 11 ty le 1/N, 12 kieu 3D/LW, 13 noi doc, 14 do doc, 15 ky hieu,
; 16 buoc vach m, 17-22 mau layer ngang/doc/cao do/do doc/vach/ten coc,
; 23 polyline lay mau theo lop goc, 24 hien cao do, 25 hien ten coc.
(cond
  ((and *TNMB:CFG* (= (length *TNMB:CFG*) 26)))
  ((and *TNMB:CFG* (= (length *TNMB:CFG*) 24))
   (setq *TNMB:CFG* (append *TNMB:CFG* '("1" "1"))))
  ((and *TNMB:CFG* (= (length *TNMB:CFG*) 17))
   (setq *TNMB:CFG* (append *TNMB:CFG* '("1" "4" "7" "3" "8" "2" "0" "1" "1"))))
  (T
   (setq *TNMB:CFG*
     (list "TK" "THAT" "TK-ADS-9402*" "TK-ADS-9407*" "TK-DBO-17*"
           "KS-TUY-2501*" "*TALUY*" *TNMB:LAYER-TK* "VNI-Times"
           "1.8" "0.05" "1" "3D" "1" "1" "1" "1"
           "1" "4" "7" "3" "8" "2" "0" "1" "1"))))
(if (not *VTL:FN*) (setq *VTL:FN* "TALUY"))

;; ---------- Hop thoai (nhom trac ngang) ----------

; O nhap / o chon -> vi tri trong CFG.
(setq *TNMB:TILES*
  '(("m_lbang" . 2) ("m_lly" . 3) ("m_ltk" . 4) ("m_lks" . 5) ("m_ltaluy" . 6)
    ("m_prefix" . 7) ("m_font" . 8) ("m_hchu" . 9) ("m_width" . 10) ("m_tyle" . 11)
    ("m_doc" . 13) ("m_dodoc" . 14) ("m_kyhieu" . 15) ("m_buoc" . 16) ("m_maugoc" . 23)
    ("m_caodo" . 24) ("m_tencoc" . 25)))

(defun TNMB:init-tiles (/ cfg p)
  (setq cfg *TNMB:CFG*)
  (foreach p *TNMB:TILES* (set_tile (car p) (nth (cdr p) cfg)))
  (set_tile (if (= (nth 0 cfg) "KS") "m_ks" "m_tk") "1")
  (set_tile (if (= (nth 1 cfg) "THANG") "m_thang" "m_that") "1")
  (set_tile (if (= (nth 12 cfg) "LW") "m_klw" "m_k3d") "1")
  (setq *TNMB:COLS* (mapcar '(lambda (p) (cons (car p) (nth (caddr p) cfg))) *TNMB:PARTS*))
  (foreach p *TNMB:PARTS* (TNMB:show-color (car p))))

; To o mau va ghi so mau ben canh.
(defun TNMB:show-color (key / c)
  (setq c (atoi (cdr (assoc key *TNMB:COLS*))))
  (start_image key)
  (fill_image 0 0 (dimx_tile key) (dimy_tile key) c)
  (end_image)
  (set_tile (strcat "t" (substr key 2)) (itoa c)))

; Bang mau AutoCAD (mau layer: khong cho ByLayer/ByBlock).
(defun TNMB:pick-color (key / c)
  (if (setq c (acad_colordlg (atoi (cdr (assoc key *TNMB:COLS*))) nil))
    (progn
      (setq *TNMB:COLS* (subst (cons key (itoa c)) (assoc key *TNMB:COLS*) *TNMB:COLS*))
      (TNMB:show-color key))))

; Doi loai: tien to layer dang la ten mac dinh thi doi theo loai.
(defun TNMB:set-type (tk / cur)
  (setq cur (get_tile "m_prefix"))
  (if (member cur (list *TNMB:LAYER-TK* *TNMB:LAYER-KS*))
    (set_tile "m_prefix" (if tk *TNMB:LAYER-TK* *TNMB:LAYER-KS*)))
  (VTL:refresh))

(defun TNMB:trim (key) (vl-string-trim " " (get_tile key)))

; Kiem tra va luu thiet lap trac ngang. Tra T neu hop le.
(defun TNMB:accept (/ tk prefix h w n step msg)
  (setq tk (= (get_tile "m_tk") "1") prefix (TNMB:trim "m_prefix")
        h (VTL:number "m_hchu") w (VTL:number "m_width")
        n (VTL:number "m_tyle") step (VTL:number "m_buoc") msg nil)
  (cond
    ((or (= prefix "") (not (snvalid (strcat prefix "-VACHTALUY"))))
     (setq msg "Tien to layer khong hop le."))
    ((member "" (mapcar 'TNMB:trim '("m_lbang" "m_lly" "m_ltk" "m_lks")))
     (setq msg "Cac o nhan dang lop khong duoc de trong."))
    ((= (TNMB:trim "m_font") "")
     (setq msg "Chua nhap font chu."))
    ((not (and h (> h 0.0)))
     (setq msg "Cao chu phai lon hon 0."))
    ((not (and w (>= w 0.0)))
     (setq msg "Global Width phai >= 0."))
    ((not (and n (> n 0.0)))
     (setq msg "Ty le 1/N: N phai lon hon 0."))
    ((and tk (= (get_tile "m_kyhieu") "1") (= (TNMB:trim "m_ltaluy") ""))
     (setq msg "Ve ky hieu taluy: phai nhap lop taluy."))
    ((and tk (= (get_tile "m_kyhieu") "1") (not (and step (> step 0.0))))
     (setq msg "Buoc vach taluy phai lon hon 0.")))
  (if msg
    (progn (alert msg) nil)
    (progn
      (setq *TNMB:PENDING*
        (append
          (list (if tk "TK" "KS")
                (if (= (get_tile "m_thang") "1") "THANG" "THAT")
                (TNMB:trim "m_lbang") (TNMB:trim "m_lly") (TNMB:trim "m_ltk")
                (TNMB:trim "m_lks") (TNMB:trim "m_ltaluy") prefix
                (TNMB:trim "m_font") (VTL:str h) (VTL:str w) (VTL:str n)
                (if (= (get_tile "m_klw") "1") "LW" "3D")
                (get_tile "m_doc") (get_tile "m_dodoc") (get_tile "m_kyhieu")
                (if (and step (> step 0.0)) (VTL:str step) (nth 16 *TNMB:CFG*)))
          (mapcar '(lambda (p) (cdr (assoc (car p) *TNMB:COLS*))) *TNMB:PARTS*)
          (list (get_tile "m_maugoc") (get_tile "m_caodo") (get_tile "m_tencoc"))))
      T)))

;; ---------- Doc chu ----------

; So khop ten lop voi wildcard (khong phan biet hoa thuong).
(defun TNMB:match (lay pat)
  (and lay pat (/= pat "") (wcmatch (strcase lay) (strcase pat))))

; Bo ma dinh dang MTEXT (\A1; \P {...}) de lay noi dung tran.
(defun TNMB:plain (s / out i n c code)
  (setq out "" i 1 n (strlen s))
  (while (<= i n)
    (setq c (substr s i 1))
    (cond
      ((member c '("{" "}")) (setq i (1+ i)))
      ((and (= c "\\") (< i n))
       (setq code (substr s (1+ i) 1))
       (cond
         ((member code '("P" "~")) (setq out (strcat out " ") i (+ i 2)))
         ((member code '("\\" "{" "}")) (setq out (strcat out code) i (+ i 2)))
         ((wcmatch code "[ACFfHQTWpa]")
          ; Ma co tham so: bo den het dau ";".
          (setq i (+ i 2))
          (while (and (<= i n) (/= (substr s i 1) ";")) (setq i (1+ i)))
          (setq i (1+ i)))
         (T (setq i (+ i 2)))))
      (T (setq out (strcat out c) i (1+ i)))))
  out)

; Noi dung TEXT/MTEXT (MTEXT: cac nhom 3 roi nhom 1).
(defun TNMB:text-string (ed / s g)
  (setq s "")
  (foreach g ed (if (= (car g) 3) (setq s (strcat s (cdr g)))))
  (TNMB:plain (strcat s (cdr (assoc 1 ed)))))

(defun TNMB:nospace (s / p)
  (while (setq p (vl-string-search " " s))
    (setq s (strcat (substr s 1 p) (substr s (+ p 2)))))
  s)

; Ky tu thuoc mot so: chu so, dau tru, dau cham, dau phay.
(defun TNMB:num-char-p (c)
  (member c '("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "-" "." ",")))

; So dau tien trong chuoi: bo ky tu dung truoc (": = "), doc lien day so.
; Khong dung wcmatch / vl-string-search chuoi rong (khac nhau giua cac ban AutoCAD).
(defun TNMB:read-num (s / i n out)
  (setq i 1 n (strlen s) out "")
  (while (and (<= i n) (not (TNMB:num-char-p (substr s i 1))))
    (setq i (1+ i)))
  (while (and (<= i n) (TNMB:num-char-p (substr s i 1)))
    (setq out (strcat out (substr s i 1)) i (1+ i)))
  (if (/= out "") (VTL:to-number out)))

; So dung sau tu khoa: "MSS: 3" -> 3. Nhan dau phay thap phan.
(defun TNMB:num-after (s key / p)
  (setq s (strcase s) p (vl-string-search key s))
  (if p (TNMB:read-num (substr s (+ p (strlen key) 1)))))

; "Km 1 + 21.97" -> 1021.97 (m). Khong dung mau -> nil.
(defun TNMB:station (s / p q km m)
  (setq s (strcase (TNMB:nospace s)) p (vl-string-search "KM" s))
  (if p
    (progn
      (setq s (substr s (+ p 3)) q (vl-string-search "+" s))
      (if (and q (> q 0))
        (progn
          (setq km (TNMB:read-num (substr s 1 q))
                m (TNMB:read-num (substr s (+ q 2))))
          (if (and km m) (+ (* 1000.0 km) m)))))))

; So -> chuoi 2 so le, bo so 0 thua (1.50 -> 1.5, 2.00 -> 2).
(defun TNMB:fmt2 (n / s)
  (setq s (rtos n 2 2))
  (if (vl-string-search "." s)
    (vl-string-right-trim "." (vl-string-right-trim "0" s))
    s))

(defun TNMB:km-str (st / km)
  (if (< st -1e-6)
    (strcat "-" (TNMB:km-str (- st)))
    (progn
      (setq km (fix (/ (+ st 1e-6) 1000.0)))
      (strcat "Km" (itoa km) "+" (rtos (abs (- st (* 1000.0 km))) 2 2)))))

;; ---------- Sap xep / ghep nhanh (khong gioi han so trac ngang) ----------

; Gan so thu tu: (y . x) -> (y k . x), de sap xep khong bao gio co 2 phan tu
; "bang nhau" (vl-sort co the bo phan tu trung).
(defun TNMB:tag (lst / k)
  (setq k 0)
  (mapcar '(lambda (e) (setq k (1+ k)) (cons (car e) (cons k (cdr e)))) lst))

; Sap tang theo khoa dau, hoa thi theo so thu tu.
(defun TNMB:ysort (lst)
  (vl-sort lst '(lambda (a b) (if (= (car a) (car b)) (< (cadr a) (cadr b)) (< (car a) (car b))))))

; Quet theo truc Y: diem ((y . p) ...) gap cua so ((y0 y1 . w) ...) khi y0 <= y <= y1.
; Tra ve ((w . p) ...), cac cap cua cung mot diem nam lien nhau.
; Thay cho vong lap long nhau diem x cua so (rat cham khi nhieu trac ngang).
(defun TNMB:sweep (pts wins / active res y)
  (setq pts (TNMB:ysort (TNMB:tag pts)) wins (TNMB:ysort (TNMB:tag wins)))
  (foreach p pts
    (setq y (car p))
    (while (and wins (<= (car (car wins)) y))
      (setq active (cons (car wins) active) wins (cdr wins)))
    (setq active (vl-remove-if '(lambda (w) (< (caddr w) y)) active))
    (foreach w active (setq res (cons (cons (cdddr w) (cddr p)) res))))
  (reverse res))

; Gom cap (chi-so . vat) thanh n nhom theo chi so 0..n-1.
(defun TNMB:group (pairs n / sorted res i cur)
  (setq sorted (TNMB:ysort (TNMB:tag pairs)) i 0)
  (repeat n
    (setq cur nil)
    (while (and sorted (= (car (car sorted)) i))
      (setq cur (cons (cddr (car sorted)) cur) sorted (cdr sorted)))
    (setq res (cons (reverse cur) res) i (1+ i)))
  (reverse res))

;; ---------- Nhan dien trac ngang ----------

(defun TNMB:ent-points (ed / g pts)
  (if (= (cdr (assoc 0 ed)) "LINE")
    (list (cdr (assoc 10 ed)) (cdr (assoc 11 ed)))
    (progn
      (foreach g ed (if (= (car g) 10) (setq pts (cons (cdr g) pts))))
      (reverse pts))))

; Phan loai doi tuong da chon -> (ngang dung chu duong).
; ngang: (y xmin xmax), dung: (x ymin ymax), chu: (dung-lop-ly-trinh noi-dung diem),
; duong: (lop dsach-diem) tren lop thiet ke/khao sat.
(defun TNMB:collect (ss cfg / pat i en ed ty lay s p q hor ver texts polys pts)
  (setq pat (if (= (nth 0 cfg) "TK") (nth 4 cfg) (nth 5 cfg)) i 0)
  (repeat (sslength ss)
    (setq en (ssname ss i) i (1+ i) ed (entget en)
          ty (cdr (assoc 0 ed)) lay (cdr (assoc 8 ed)))
    (cond
      ((member ty '("TEXT" "MTEXT"))
       (setq s (TNMB:text-string ed))
       (if (or (vl-string-search "KM" (strcase s)) (vl-string-search "MSS" (strcase s)))
         (setq texts (cons (list (TNMB:match lay (nth 3 cfg)) s (cdr (assoc 10 ed))) texts))))
      ((and (= ty "LINE") (TNMB:match lay (nth 2 cfg)))
       (setq p (cdr (assoc 10 ed)) q (cdr (assoc 11 ed)))
       (cond
         ((and (< (abs (- (cadr p) (cadr q))) 1e-5) (> (abs (- (car p) (car q))) 1e-5))
          (setq hor (cons (list (cadr p) (min (car p) (car q)) (max (car p) (car q))) hor)))
         ((and (< (abs (- (car p) (car q))) 1e-5) (> (abs (- (cadr p) (cadr q))) 1e-5))
          (setq ver (cons (list (car p) (min (cadr p) (cadr q)) (max (cadr p) (cadr q))) ver))))))
    ; Thanh phan mat cat (LINE co the vua la doi tuong bang neu lop trung).
    (if (and (member ty '("LINE" "LWPOLYLINE")) (TNMB:match lay pat))
      (progn
        (setq pts (TNMB:ent-points ed))
        (if (cdr pts) (setq polys (cons (list lay pts) polys))))))
  (list hor ver texts polys))

; Chu ly trinh / MSS cua CA ban ve (khong gian hien hanh), phong khi quet chon
; khong trum dong chu ly trinh phia tren khung hoac chu MSS. Gan theo vi tri mat cat.
(defun TNMB:all-texts (cfg / ss i ed res)
  (if (setq ss (ssget "_X" (list '(0 . "TEXT,MTEXT")
                                 '(1 . "*[Kk][Mm]*,*[Mm][Ss][Ss]*")
                                 (cons 410 (getvar "CTAB")))))
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (setq ed (entget (ssname ss i)) i (1+ i))
        (setq res (cons (list (TNMB:match (cdr (assoc 8 ed)) (nth 3 cfg))
                              (TNMB:text-string ed) (cdr (assoc 10 ed)))
                        res)))))
  res)

; Duong tim = LINE dung co chan nam TRONG doan ngang mep tren bang.
; Ket qua: (x-tim y-chan y-dinh x-trai-bang x-phai-bang).
(defun TNMB:raw-sections (hor ver / pr h v prevv res)
  (foreach pr (TNMB:sweep (mapcar '(lambda (v) (cons (cadr v) v)) ver)
                          (mapcar '(lambda (h) (cons (- (car h) 1e-5) (cons (+ (car h) 1e-5) h)))
                                  hor))
    (setq h (car pr) v (cdr pr))
    (if (and (> (car v) (+ (cadr h) 1e-4)) (< (car v) (- (caddr h) 1e-4))
             ; 1 duong tim trung 2 duong ngang chong nhau -> chi lay 1 lan
             (not (equal v prevv)))
      (setq res (cons (list (car v) (cadr v) (caddr v) (cadr h) (caddr h)) res)
            prevv v)))
  (reverse res))

; Cap (chi-so-mat-cat . chu) cho chu nam trong vung ly trinh + MSS cua tung mat cat.
(defun TNMB:text-pairs (texts raw / r wins H pr w x res)
  (setq r 0)
  (foreach w raw
    (setq H (- (nth 2 w) (nth 1 w))
          wins (cons (cons (- (nth 1 w) (* 0.1 H)) (cons (+ (nth 2 w) (* 0.5 H)) (cons r w)))
                     wins)
          r (1+ r)))
  (foreach pr (TNMB:sweep (mapcar '(lambda (item) (cons (cadr (caddr item)) item)) texts) wins)
    ; w = (r x-tim y-chan y-dinh x-trai x-phai)
    (setq w (car pr) H (- (nth 3 w) (nth 2 w)) x (car (caddr (cdr pr))))
    (if (and (>= x (- (nth 4 w) (* 0.1 H))) (<= x (+ (nth 5 w) 1e-6)))
      (setq res (cons (cons (car w) (cdr pr)) res))))
  res)

; Ly trinh gan dinh duong tim nhat; uu tien chu tren lop ly trinh.
(defun TNMB:find-station (texts raw / H best bd pass item pt val d)
  (setq H (- (nth 2 raw) (nth 1 raw)))
  (foreach pass '(T nil)
    (if (null best)
      (foreach item texts
        (setq pt (caddr item))
        (if (and (or (not pass) (car item))
                 (>= (car pt) (- (nth 3 raw) 1e-6)) (<= (car pt) (+ (nth 4 raw) 1e-6))
                 (>= (cadr pt) (- (nth 2 raw) (* 0.1 H)))
                 (<= (cadr pt) (+ (nth 2 raw) (* 0.5 H)))
                 (setq val (TNMB:station (cadr item))))
          (progn
            (setq d (distance (list (car pt) (cadr pt)) (list (nth 0 raw) (nth 2 raw))))
            (if (or (null bd) (< d bd)) (setq bd d best val)))))))
  best)

; MSS: chu "MSS" sat goc trai mep tren bang.
(defun TNMB:find-mss (texts raw / H best bd item pt val d)
  (setq H (- (nth 2 raw) (nth 1 raw)))
  (foreach item texts
    (setq pt (caddr item))
    (if (and (vl-string-search "MSS" (strcase (cadr item)))
             (>= (car pt) (- (nth 3 raw) (* 0.1 H))) (<= (car pt) (nth 4 raw))
             (<= (abs (- (cadr pt) (nth 1 raw))) (* 0.1 H))
             (setq val (TNMB:num-after (cadr item) "MSS")))
      (progn
        (setq d (distance (list (car pt) (cadr pt)) (list (nth 3 raw) (nth 1 raw))))
        (if (or (null bd) (< d bd)) (setq bd d best val)))))
  best)

; Gan moi duong vao trac ngang chua tam bao cua no (gan tim nhat).
; Trac ngang: (ly-trinh x-tim y-chan y-dinh x-trai x-phai MSS). Ket qua: ((chi-so lop diem) ...)
(defun TNMB:assign (polys secs / s H wins id pts item xs ys pr w p d cur best bd res)
  (setq s 0)
  (foreach sec secs
    (setq H (- (nth 3 sec) (nth 2 sec))
          wins (cons (cons (- (nth 2 sec) (* 0.5 H)) (cons (+ (nth 3 sec) (* 0.5 H)) (cons s sec)))
                     wins)
          s (1+ s)))
  ; Diem dai dien = tam bao: (my id mx my lop diem)
  (setq id 0)
  (foreach item polys
    (setq xs (mapcar 'car (cadr item)) ys (mapcar 'cadr (cadr item)) id (1+ id))
    (setq p (list id (* 0.5 (+ (apply 'min xs) (apply 'max xs)))
                     (* 0.5 (+ (apply 'min ys) (apply 'max ys)))))
    (setq pts (cons (cons (caddr p) (append p item)) pts)))
  (foreach pr (append (TNMB:sweep pts wins) (list nil))
    ; Het cac cap cua 1 duong -> chot trac ngang gan nhat.
    (if (and cur (or (null pr) (/= (car (cdr pr)) (car cur))))
      (progn
        (if best (setq res (cons (cons best (cdddr cur)) res)))
        (setq cur nil best nil bd nil)))
    (if pr
      (progn
        ; w = (s ly-trinh x-tim y-chan y-dinh x-trai x-phai MSS), p = (id mx my lop diem)
        (setq w (car pr) p (cdr pr) cur p)
        (if (and (>= (cadr p) (nth 5 w)) (<= (cadr p) (nth 6 w)))
          (progn
            (setq d (+ (abs (- (cadr p) (nth 2 w)))
                       (abs (- (caddr p) (* 0.5 (+ (nth 3 w) (nth 4 w)))))))
            (if (or (null bd) (< d bd)) (setq bd d best (car w))))))))
  res)

;; ---------- Thanh phan va toa do ----------

; Bo diem trung lien tiep. Diem: (off z).
(defun TNMB:dedupe (pts / out p)
  (foreach p pts
    (if (or (null out)
            (> (distance (list (car p) (cadr p)) (list (caar out) (cadar out))) 1e-6))
      (setq out (cons p out))))
  (reverse out))

; Thanh phan: (lop phia diem...) ; phia L/R/C; diem: (khoa off z).
; Diem xep tu phia tim ra ngoai (C: trai -> phai). Khoa = lop|phia|thu-tu, diem
; ngoai cung la "E" de noi doc duoc khi so dinh (giat co) thay doi giua cac coc.
(defun TNMB:component (lay pts sec ks / e lst o1 o2 side prefix n i)
  (setq e 1e-6
        lst (TNMB:dedupe
              (mapcar '(lambda (p) (list (- (car p) (nth 1 sec))
                                         (+ (nth 6 sec) (- (cadr p) (nth 2 sec)))))
                      pts)))
  (if (cdr lst)
    (progn
      (setq o1 (car (car lst)) o2 (car (last lst)))
      (setq side (cond ((and (<= o1 e) (<= o2 e)) "L")
                       ((and (>= o1 (- e)) (>= o2 (- e))) "R")
                       (T "C")))
      (if (or (and (= side "L") (< o1 o2))
              (and (= side "R") (> o1 o2))
              (and (= side "C") (> o1 o2)))
        (setq lst (reverse lst)))
      (setq prefix (strcat lay "|" side "|") n (length lst) i 0)
      (list lay side
        (mapcar '(lambda (p)
                   (setq i (1+ i))
                   (cons (cond (ks (cond ((= i 1) (strcat prefix "DAU"))
                                         ((= i n) (strcat prefix "CUOI"))))
                               ((= i n) (strcat prefix "E"))
                               (T (strcat prefix (itoa (1- i)))))
                         p))
                lst)))))

; Khung dinh vi tai ly trinh: (diem-tim-2D huong-tuyen-don-vi) hoac nil.
; THAT : data = (tim-tuyen d-moc ly-trinh-moc chieu chieu-dai)
;        khoang cach tren tim tuyen d = d-moc + chieu * (ly trinh - ly-trinh-moc);
;        chieu = -1 khi polyline ve nguoc chieu ly trinh.
; THANG: data = (diem-goc huong ly-trinh-goc)
(defun TNMB:frame (st mode data / obj dir len d p par der u)
  (if (= mode "THAT")
    (progn
      (setq obj (car data) dir (nth 3 data) len (nth 4 data)
            d (+ (cadr data) (* dir (- st (caddr data)))))
      (if (and (>= d -1e-6) (<= d (+ len 1e-6)))
        (progn
          (setq d (max 0.0 (min d len))
                p (vlax-curve-getPointAtDist obj d)
                par (vlax-curve-getParamAtDist obj d)
                der (if par (vlax-curve-getFirstDeriv obj par))
                u (if der (VTL:unit (list (* dir (car der)) (* dir (cadr der))))))
          (if (and p u) (list (list (car p) (cadr p)) u)))))
    (list (VTL:plus (car data) (cadr data) (- st (caddr data))) (cadr data))))

; Ly trinh go tay: "1540", "1540.5", "Km1+540", "1+540" -> met. Sai -> nil.
(defun TNMB:parse-st (s / p a b)
  (setq s (strcase (TNMB:nospace s)))
  (if (setq p (vl-string-search "KM" s)) (setq s (substr s (+ p 3))))
  (cond
    ((= s "") nil)
    ((setq p (vl-string-search "+" s))
     (if (and (> p 0)
              (setq a (TNMB:read-num (substr s 1 p)))
              (setq b (TNMB:read-num (substr s (+ p 2)))))
       (+ (* 1000.0 a) b)))
    (T (TNMB:read-num s))))

; Hoi ly trinh; Enter = mac dinh; go sai thi hoi lai.
(defun TNMB:ask-st (msg def / s v again)
  (setq again T)
  (while again
    (setq s (vl-string-trim " " (getstring T (strcat msg " (vd 1540 hoac Km1+540) <"
                                                    (TNMB:km-str def) ">: "))))
    (cond
      ((= s "") (setq v def again nil))
      ((setq v (TNMB:parse-st s)) (setq again nil))
      (T (princ "\nLy trinh khong hop le."))))
  v)

; Diem moc tren tim tuyen: (khoang-cach-tren-tuyen ly-trinh) hoac nil neu Enter.
; Enter o lan hoi dau = diem dau polyline. chord: (dinh khoang-cach) neu tuyen gay khuc.
(defun TNMB:ask-mark (align chord msg first / pt w pr q d)
  (setq pt (getpoint msg))
  (cond
    (pt
      (setq w (trans pt 1 0))
      (if chord
        (setq pr (TNMB:ch-project (car chord) (cadr chord) w) d (car pr) q (cadr pr))
        (setq q (vlax-curve-getClosestPointTo align w)
              d (vlax-curve-getDistAtPoint align q)))
      (if (> (distance (list (car q) (cadr q)) (list (car w) (cadr w))) 0.01)
        (princ (strcat "\n(!) Diem pick cach tim tuyen "
                       (rtos (distance (list (car q) (cadr q)) (list (car w) (cadr w))) 2 3)
                       " m, lay hinh chieu len tim tuyen.")))
      (list d (TNMB:ask-st "\nLy trinh tai diem moc" 0.0)))
    (first
      (list 0.0 (TNMB:ask-st "\nLy trinh tai DIEM DAU polyline tim tuyen" 0.0)))))

;; ---------- Tim tuyen gay khuc qua tam coc (vd 3D polyline tim cua ADS) ----------
;; Polyline khong co cung: moi dinh la tam 1 coc. Tinh 2D, khop coc vao dinh de khong
;; tich luy sai so day cung; tiep tuyen tai dinh theo duong tron qua 3 dinh lien ke.

; Dinh 2D cua polyline khong co cung (LWPOLYLINE/POLYLINE/3D POLYLINE); nil neu co cung.
(defun TNMB:chord-verts (en / ed ty ok g v vd n k p pts)
  (setq ed (entget en) ty (cdr (assoc 0 ed)) ok T)
  (cond
    ((= ty "LWPOLYLINE")
     (foreach g ed (if (and (= (car g) 42) (> (abs (cdr g)) 1e-9)) (setq ok nil))))
    ((= ty "POLYLINE")
     (if (= 0 (logand 8 (cdr (assoc 70 ed))))
       (progn
         (setq v (entnext en))
         (while (and v (= (cdr (assoc 0 (setq vd (entget v)))) "VERTEX"))
           (if (and (assoc 42 vd) (> (abs (cdr (assoc 42 vd))) 1e-9)) (setq ok nil))
           (setq v (entnext v))))))
    (T (setq ok nil)))
  (if ok
    (progn
      (setq n (fix (+ 0.5 (vlax-curve-getEndParam en))) k 0)
      (repeat (1+ n)
        (setq p (vlax-curve-getPointAtParam en k)
              pts (cons (list (car p) (cadr p)) pts) k (1+ k)))
      (setq pts (TNMB:dedupe (reverse pts)))
      (if (cdr pts) pts))))

; Khoang cach tich luy 2D tai cac dinh.
(defun TNMB:cum (pts / c d prev p)
  (setq d 0.0)
  (foreach p pts
    (if prev (setq d (+ d (distance prev p))))
    (setq c (cons d c) prev p))
  (reverse c))

; Diem tai khoang cach d.
(defun TNMB:ch-point (pts cum d / res a b ca cb)
  (while (and (null res) (cdr pts))
    (setq a (car pts) b (cadr pts) ca (car cum) cb (cadr cum))
    (if (or (<= d (+ cb 1e-9)) (null (cddr pts)))
      (setq res (TNMB:lerp a b (/ (- d ca) (- cb ca))))
      (setq pts (cdr pts) cum (cdr cum))))
  res)

; Huong doan chua khoang cach d.
(defun TNMB:ch-dir (pts cum d / res)
  (while (and (null res) (cdr pts))
    (if (or (<= d (+ (cadr cum) 1e-9)) (null (cddr pts)))
      (setq res (VTL:unit (VTL:sub (cadr pts) (car pts))))
      (setq pts (cdr pts) cum (cdr cum))))
  res)

; Hinh chieu diem q: (khoang-cach-doc-tuyen diem-chieu).
(defun TNMB:ch-project (pts cum q / a b ab L2 k c dd bd best)
  (setq q (list (car q) (cadr q)))
  (while (cdr pts)
    (setq a (car pts) b (cadr pts) ab (VTL:sub b a) L2 (VTL:dot ab ab))
    (if (> L2 1e-18)
      (progn
        (setq k (max 0.0 (min 1.0 (/ (VTL:dot (VTL:sub q a) ab) L2)))
              c (VTL:plus a ab k) dd (distance c q))
        (if (or (null bd) (< dd bd))
          (setq bd dd best (list (+ (car cum) (* k (- (cadr cum) (car cum)))) c)))))
    (setq pts (cdr pts) cum (cdr cum)))
  best)

; Tiep tuyen tai P cua duong tron qua R-P-Q (thang hang: huong R->Q), chieu R->Q.
(defun TNMB:tangent3 (r p q / ax ay bx by d cx cy u)
  (setq ax (- (car r) (car p)) ay (- (cadr r) (cadr p))
        bx (- (car q) (car p)) by (- (cadr q) (cadr p))
        d (* 2.0 (- (* ax by) (* ay bx))))
  (if (< (abs d) (* 1e-9 (+ (* ax ax) (* ay ay) (* bx bx) (* by by))))
    (VTL:unit (VTL:sub q r))
    (progn
      ; Tam duong tron (goc toa do tai P); tiep tuyen vuong goc ban kinh.
      (setq cx (/ (- (* by (+ (* ax ax) (* ay ay))) (* ay (+ (* bx bx) (* by by)))) d)
            cy (/ (- (* ax (+ (* bx bx) (* by by))) (* bx (+ (* ax ax) (* ay ay)))) d)
            u (VTL:unit (list (- cy) cx)))
      (if (and u (< (VTL:dot u (VTL:sub q r)) 0.0)) (list (- (car u)) (- (cadr u))) u))))

; Chi so dinh gan khoang cach d nhat trong dung sai, nil neu khong co.
(defun TNMB:ch-snap (cum d tol / j bd best c)
  (setq j 0)
  (foreach c cum
    (if (and (<= (abs (- c d)) tol) (or (null bd) (< (abs (- c d)) bd)))
      (setq bd (abs (- c d)) best j))
    (setq j (1+ j)))
  best)

; Ly trinh (tang dan) -> ((ly-trinh khoang-cach chi-so-dinh) ...). Di tu moc ra 2 phia,
; moi coc tinh tu coc truoc (khong cong don sai so day cung) va khop vao dinh gan nhat.
(defun TNMB:ch-map (sts cum d1 st1 dir / up dn lst st pd ps e tol j d res)
  (foreach st sts (if (>= st st1) (setq up (cons st up)) (setq dn (cons st dn))))
  (foreach lst (list (reverse up) dn)
    (setq pd d1 ps st1)
    (foreach st lst
      (setq e (+ pd (* dir (- st ps)))
            tol (max 0.05 (min 1.0 (* 0.3 (abs (- st ps)))))
            j (TNMB:ch-snap cum e tol)
            d (if j (nth j cum) e)
            res (cons (list st d j) res)
            pd d ps st)))
  res)

; Ba diem thang hang (lech huong < 1e-6 rad).
(defun TNMB:collinear (a b c / u v)
  (setq u (VTL:sub b a) v (VTL:sub c b))
  (< (abs (VTL:cross u v)) (* 1e-6 (VTL:length u) (VTL:length v))))

; Khung tai coc tren tuyen gay khuc: item = (khoang-cach chi-so-dinh).
; Tiep tuyen tai dinh: ket thuc doan thang (coc TD) / bat dau doan thang (coc TC) thi
; theo doan thang; trong duong cong theo duong tron qua 3 dinh lien ke.
(defun TNMB:ch-frame (item verts cum dir len / d j n p u)
  (setq d (car item) j (cadr item) n (length verts))
  (if (and d (>= d -1e-6) (<= d (+ len 1e-6)))
    (progn
      (if j
        (setq p (nth j verts)
              u (cond ((= j 0) (VTL:unit (VTL:sub (nth 1 verts) p)))
                      ((= j (1- n)) (VTL:unit (VTL:sub p (nth (- n 2) verts))))
                      ((and (>= j 2) (TNMB:collinear (nth (- j 2) verts) (nth (1- j) verts) p))
                       (VTL:unit (VTL:sub p (nth (1- j) verts))))
                      ((and (<= j (- n 3)) (TNMB:collinear p (nth (1+ j) verts) (nth (+ j 2) verts)))
                       (VTL:unit (VTL:sub (nth (1+ j) verts) p)))
                      (T (TNMB:tangent3 (nth (1- j) verts) p (nth (1+ j) verts)))))
        (setq p (TNMB:ch-point verts cum (max 0.0 (min d len)))
              u (TNMB:ch-dir verts cum (max 0.0 (min d len)))))
      (if (and p u) (list p (list (* dir (car u)) (* dir (cadr u))))))))

; Diem mat bang = tim - off * phap-tuyen-trai (off < 0 la ben trai).
(defun TNMB:plan (frame off z / p u)
  (setq p (car frame) u (cadr frame))
  (list (+ (car p) (* off (cadr u))) (- (cadr p) (* off (car u))) z))

; Diem tim (off = 0): dinh co san, neu khong thi noi suy tren duong.
(defun TNMB:tim (comps frame / best c a b lst z)
  (foreach c comps
    (foreach a (caddr c)
      (if (and (null best) (< (abs (cadr a)) 1e-4)) (setq best (cadddr a)))))
  (if (null best)
    (foreach c comps
      (setq lst (caddr c))
      (while (and (null best) (cdr lst))
        (setq a (car lst) b (cadr lst) lst (cdr lst))
        (if (and (<= (min (cadr a) (cadr b)) 0.0) (>= (max (cadr a) (cadr b)) 0.0)
                 (> (abs (- (cadr b) (cadr a))) 1e-9))
          (setq z (+ (caddr a) (* (- (caddr b) (caddr a))
                                  (/ (- (cadr a)) (- (cadr b) (cadr a)))))
                best (TNMB:plan frame 0.0 z))))))
  best)

;; ---------- Ve ----------

(defun TNMB:c (k) (cdr (assoc k *TNMB:CTX*)))

(defun TNMB:flat (p) (list (car p) (cadr p) (if (TNMB:c '3d) (caddr p) 0.0)))

; Mau lop goc (cho tuy chon polyline theo mau lop goc); nil = theo layer ket qua.
(defun TNMB:src-color (lay / ed)
  (if (and lay (setq ed (tblsearch "LAYER" lay)) (assoc 62 ed))
    (abs (cdr (assoc 62 ed)))))

; Polyline 3D (hoac LWPolyline co Global Width) tren layer lay; col nil = ByLayer.
(defun TNMB:pline (pts lay col / cl p)
  (setq cl (if col (list (cons 62 col))))
  (if (TNMB:c '3d)
    (progn
      (entmake (append (list '(0 . "POLYLINE") (cons 8 lay)) cl
                       (list '(66 . 1) '(10 0.0 0.0 0.0) '(70 . 8))))
      (foreach p pts
        (entmake (append (list '(0 . "VERTEX") (cons 8 lay)) cl
                         (list (cons 10 p) '(70 . 32)))))
      (entmake (list '(0 . "SEQEND") (cons 8 lay))))
    (entmake (append (list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") (cons 8 lay)) cl
                     (list '(100 . "AcDbPolyline") (cons 90 (length pts)) '(70 . 0)
                           (cons 43 (TNMB:c 'w)) '(38 . 0.0))
                     (mapcar '(lambda (p) (cons 10 (list (car p) (cadr p)))) pts)))))

(defun TNMB:line (p q)
  (entmake (list '(0 . "LINE") (cons 8 (TNMB:c 'L-vach))
                 (cons 10 (TNMB:flat p)) (cons 11 (TNMB:flat q)))))

; Huong chu doc duoc (quay ve phia phai / len tren).
(defun TNMB:readable (v)
  (if (or (< (car v) -1e-9) (and (< (abs (car v)) 1e-9) (< (cadr v) 0.0)))
    (list (- (car v)) (- (cadr v)))
    v))

(defun TNMB:perp (v) (list (- (cadr v)) (car v)))

(defun TNMB:offset (p v dv n dn)
  (list (+ (car p) (* dv (car v)) (* dn (car n)))
        (+ (cadr p) (* dv (cadr v)) (* dn (cadr n)))
        (if (caddr p) (caddr p) 0.0)))

(defun TNMB:mid (a b) (mapcar '(lambda (x y) (* 0.5 (+ x y))) a b))

(defun TNMB:lerp (a b s) (mapcar '(lambda (x y) (+ x (* s (- y x)))) a b))

; Chu tai pt theo huong v; hj 0 trai, 1 giua, 2 phai (tren duong chan chu).
(defun TNMB:text (pt str v hj lay / ins)
  (setq ins (TNMB:flat pt))
  (entmake (list '(0 . "TEXT") (cons 8 lay) (cons 7 (TNMB:c 'style))
                 (cons 10 ins) (cons 11 ins) (cons 40 (TNMB:c 'h)) (cons 1 str)
                 (cons 50 (atan (cadr v) (car v))) '(41 . 1.0)
                 (cons 72 hj) '(73 . 0))))

; Do doc: taluy (doc hon 1:10) ghi 1:m, con lai (mat duong, le, co taluy) ghi %.
(defun TNMB:slope-str (doff dz taluy / s)
  (setq s (/ (abs dz) (abs doff)))
  (if (and taluy (>= s 0.1) (> (abs dz) 1e-9))
    (strcat "1:" (TNMB:fmt2 (/ 1.0 s)))
    (strcat (TNMB:fmt2 (* 100.0 s)) "%")))

; Ve 1 trac ngang: polyline tung thanh phan, cao do tung diem, do doc, ten coc.
(defun TNMB:draw-section (sd / sec u v n2 h seen c pts p key lst a b w taluy left dirn)
  (setq sec (car sd) u (cadr (cadr sd)) h (TNMB:c 'h)
        v (TNMB:readable u) n2 (TNMB:perp v) seen nil left nil)
  (foreach c (caddr sd)
    (setq pts (mapcar 'cadddr (caddr c)))
    (TNMB:pline pts (TNMB:c 'L-ngang) (if (TNMB:c 'maugoc) (TNMB:src-color (car c))))
    (setq *TNMB:N-NGANG* (1+ *TNMB:N-NGANG*))
    ; Cao do: moi vi tri ghi 1 lan, chu song song tuyen, nam canh diem.
    (foreach p (caddr c)
      (if (or (null left) (< (cadr p) (cadr left))) (setq left p))
      (setq key (strcat (rtos (car (cadddr p)) 2 4) "," (rtos (cadr (cadddr p)) 2 4)))
      (if (and (TNMB:c 'caodo) (not (member key seen)))
        (progn
          (setq seen (cons key seen))
          (TNMB:text (TNMB:offset (cadddr p) v (* 0.5 h) n2 (* 0.3 h))
                     (rtos (/ (caddr p) (TNMB:c 'm2cad)) 2 2) v 0 (TNMB:c 'L-caodo))
          (setq *TNMB:N-CHU* (1+ *TNMB:N-CHU*)))))
    ; Do doc tung doan (bo doan dung nhu mat bo via).
    (if (TNMB:c 'slope)
      (progn
        (setq taluy (TNMB:match (car c) (TNMB:c 'ltaluy)) lst (caddr c))
        (while (cdr lst)
          (setq a (car lst) b (cadr lst) lst (cdr lst))
          (if (and (> (abs (- (cadr b) (cadr a))) 1e-4)
                   (setq w (VTL:unit (VTL:sub (cadddr b) (cadddr a)))))
            (progn
              (setq w (TNMB:readable w))
              (TNMB:text (TNMB:offset (TNMB:mid (cadddr a) (cadddr b)) w 0.0
                                      (TNMB:perp w) (* 0.3 h))
                         (TNMB:slope-str (- (cadr b) (cadr a)) (- (caddr b) (caddr a)) taluy)
                         w 1 (TNMB:c 'L-dodoc))
              (setq *TNMB:N-DOC* (1+ *TNMB:N-DOC*))))))))
  ; Ten coc o dau trai mat cat, theo phuong mat cat.
  (if (and left (TNMB:c 'tencoc))
    (progn
      (setq dirn (TNMB:perp u)
            w (TNMB:readable dirn)
            p (TNMB:offset (cadddr left) dirn h dirn 0.0))
      (TNMB:text (TNMB:offset p w 0.0 (TNMB:perp w) (* -0.5 h))
                 (TNMB:km-str (car sec)) w
                 (if (> (+ (* (car w) (car dirn)) (* (cadr w) (cadr dirn))) 0.0) 0 2)
                 (TNMB:c 'L-ten)))))

(defun TNMB:sig (pts / s p)
  (setq s "")
  (foreach p pts
    (setq s (strcat s (rtos (car p) 2 3) "," (rtos (cadr p) 2 3) ","
                    (rtos (caddr p) 2 3) ";")))
  s)

; Noi doc: cac diem cung khoa o cac coc lien tiep -> 1 polyline; bo duong trung.
; Bang moi coc: ((khoa diem lop-goc) ...).
(defun TNMB:longitudinal (sds / keys tables tb sd c p key cur lay sig sigs n)
  (foreach sd sds
    (setq tb (if (nth 3 sd) (list (list "TIM" (nth 3 sd) nil))))
    (foreach c (caddr sd)
      (foreach p (caddr c)
        (if (and (car p) (not (assoc (car p) tb)))
          (setq tb (cons (list (car p) (cadddr p) (car c)) tb)))))
    (setq tables (cons tb tables))
    (foreach p (reverse tb)
      (if (not (member (car p) keys)) (setq keys (cons (car p) keys)))))
  (setq tables (reverse tables) n 0)
  (foreach key (reverse keys)
    (setq cur nil lay nil)
    (foreach tb (append tables (list nil))
      (if (setq p (assoc key tb))
        (setq cur (cons (cadr p) cur) lay (caddr p))
        (progn
          (if (cdr cur)
            (progn
              (setq sig (TNMB:sig cur))
              (if (not (member sig sigs))
                (progn
                  (setq sigs (cons sig sigs))
                  (TNMB:pline (reverse cur) (TNMB:c 'L-doc)
                              (if (TNMB:c 'maugoc) (TNMB:src-color lay)))
                  (setq n (1+ n))))))
          (setq cur nil)))))
  n)

(defun TNMB:steep (a b / doff)
  (setq doff (abs (- (cadr b) (cadr a))))
  (and (> doff 1e-4) (>= (abs (- (caddr b) (caddr a))) (* 0.1 doff))))

; Vach taluy giua 2 coc: tu mep tren (tA-tB) xuong mep duoi (bA-bB),
; xen ke vach dai / vach ngan (1/2), buoc theo mep tren.
(defun TNMB:tick-band (tA bA tB bB / len n j k p q)
  (setq len (distance (list (car tA) (cadr tA)) (list (car tB) (cadr tB)))
        n (max 1 (fix (+ 0.5 (/ len (TNMB:c 'step))))) j 0)
  (repeat n
    (if (< *TNMB:N-VACH* 1000000)
      (progn
        (setq k (/ (float j) n) p (TNMB:lerp tA tB k) q (TNMB:lerp bA bB k))
        (if (= 1 (rem *TNMB:N-VACH* 2)) (setq q (TNMB:lerp p q 0.5)))
        (TNMB:line p q)
        (setq *TNMB:N-VACH* (1+ *TNMB:N-VACH*))))
    (setq j (1+ j))))

; Ky hieu taluy giua 2 coc ke nhau: doan doc (khong phai co) cung khoa o ca 2 coc.
(defun TNMB:ticks (sdA sdB / cA cB c lst a1 a2 b1 b2)
  (foreach cA (caddr sdA)
    (if (TNMB:match (car cA) (TNMB:c 'ltaluy))
      (progn
        (setq cB nil)
        (foreach c (caddr sdB)
          (if (and (null cB) (= (car c) (car cA)) (= (cadr c) (cadr cA))) (setq cB c)))
        (if cB
          (progn
            (setq lst (caddr cA))
            (while (cdr lst)
              (setq a1 (car lst) a2 (cadr lst) lst (cdr lst)
                    b1 (assoc (car a1) (caddr cB)) b2 (assoc (car a2) (caddr cB)))
              ; Bo doan ma dinh/chan dao nhau giua 2 coc (chuyen dao <-> dap).
              (if (and b1 b2 (TNMB:steep a1 a2) (TNMB:steep b1 b2)
                       (eq (>= (caddr a1) (caddr a2)) (>= (caddr b1) (caddr b2))))
                (if (>= (caddr a1) (caddr a2))
                  (TNMB:tick-band (cadddr a1) (cadddr a2) (cadddr b1) (cadddr b2))
                  (TNMB:tick-band (cadddr a2) (cadddr a1) (cadddr b2) (cadddr b1)))))))))))

;; ---------- Chuan bi ----------

; 1 mm ban in -> don vi ban ve.
(defun TNMB:mm->cad (/ ins)
  (setq ins (getvar "INSUNITS"))
  (cond ((= ins 4) 1.0) ((= ins 5) 0.1) ((= ins 6) 0.001)
        ((= ins 0) (princ "\n(!) INSUNITS = 0: coi ban ve don vi met.") 0.001)))

; Tao layer (mau chon, net in 0.05 mm) hoac doi mau layer da co theo lua chon.
(defun TNMB:prepare-layer (name color / layers obj)
  (if (VTL:layer-visible name)
    (progn
      (setq layers (vla-get-Layers (vla-get-ActiveDocument (vlax-get-acad-object))))
      (if (tblsearch "LAYER" name)
        (progn
          (setq obj (vl-catch-all-apply 'vla-Item (list layers name)))
          (if (not (vl-catch-all-error-p obj))
            (vl-catch-all-apply 'vla-put-Color (list obj color)))
          name)
        (if (VTL:layer name color)
          (progn
            (setq obj (vl-catch-all-apply 'vla-Item (list layers name)))
            (if (not (vl-catch-all-error-p obj))
              (vl-catch-all-apply 'vla-put-Lineweight (list obj 5)))
            name))))))

; Kieu chu TNMB-VNI dung font TrueType (mac dinh VNI-Times).
(defun TNMB:style (font / name styles obj dirs found d)
  (setq name "TNMB-VNI"
        styles (vla-get-TextStyles (vla-get-ActiveDocument (vlax-get-acad-object)))
        obj (vl-catch-all-apply 'vla-Item (list styles name)))
  (if (vl-catch-all-error-p obj)
    (setq obj (vl-catch-all-apply 'vla-Add (list styles name))))
  (if (vl-catch-all-error-p obj)
    (progn (princ "\n(!) Khong tao duoc kieu chu TNMB-VNI, dung Standard.") "Standard")
    (progn
      (if (vl-catch-all-error-p
            (vl-catch-all-apply 'vla-SetFont (list obj font :vlax-false :vlax-false 0 0)))
        (princ (strcat "\n(!) Khong dat duoc font " font ".")))
      (vl-catch-all-apply 'vla-put-Height (list obj 0.0))
      (if (wcmatch (strcase font) "VNI*")
        (progn
          (setq dirs (list (if (getenv "WINDIR") (strcat (getenv "WINDIR") "\\Fonts"))
                           (if (getenv "LOCALAPPDATA")
                             (strcat (getenv "LOCALAPPDATA") "\\Microsoft\\Windows\\Fonts"))))
          (foreach d dirs
            (if (and d (vl-directory-files d "VNI*.TTF" 1)) (setq found T)))
          (if (not found)
            (princ "\n(!) Khong thay font VNI*.TTF tren may: AutoCAD se thay bang font khac."))))
      name)))

(defun TNMB:curve-len (obj / e r)
  (setq e (vl-catch-all-apply 'vlax-curve-getEndParam (list obj)))
  (if (and (not (vl-catch-all-error-p e)) (numberp e))
    (progn
      (setq r (vl-catch-all-apply 'vlax-curve-getDistAtParam (list obj e)))
      (if (and (not (vl-catch-all-error-p r)) (numberp r) (> r 0.0)) r))))

;; ---------- Thuc hien (goi tu lenh VTL sau khi chon chuc nang trac ngang) ----------

(defun TNMB:run (/ *error* doc oldvars undo cfg ks mm2cad m2cad ss data raw texts groups
                   cands prev secs sec st mss sds comps item c cp frame mode pdata pick
                   align len st0 base dirpt u i n-doc stop sd ed use layers lay ok p
                   m1 m2 dir ratio sdf sdl chord chmap)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object))
        oldvars (mapcar '(lambda (x) (cons x (getvar x)))
                        '("OSMODE" "CMDECHO" "CLAYER" "ORTHOMODE" "DIMZIN"))
        undo nil)
  (defun *error* (msg)
    (if undo (progn (vla-EndUndoMark doc) (setq undo nil)))
    (foreach item oldvars (setvar (car item) (cdr item)))
    (setq *TNMB:CTX* nil)
    (if (and msg (not (wcmatch (strcase msg) "*CANCEL*,*QUIT*,*EXIT*")))
      (princ (strcat "\nTNMB loi: " msg)))
    (princ))
  (cond
    ((null (setq mm2cad (TNMB:mm->cad)))
     (alert "INSUNITS cua ban ve khong phai mm/cm/m. Kiem tra don vi truoc khi trien khai."))
    (T
      (setq cfg *TNMB:CFG* mode (nth 1 cfg) m2cad (* 1000.0 mm2cad) ks (= (nth 0 cfg) "KS"))
      (vla-StartUndoMark doc) (setq undo T)
      (setvar "CMDECHO" 0) (setvar "DIMZIN" 0)
      ;; 1. Chon trac ngang (khong gioi han so luong)
      (princ (strcat "\nQuet chon cac trac ngang " (if ks "KHAO SAT" "THIET KE")
                     ", Enter de trien khai:"))
      (setq ss (ssget '((0 . "LINE,LWPOLYLINE,TEXT,MTEXT"))))
      (if (null ss) (setq stop "Khong chon doi tuong nao."))
      ;; 2. Nhan dien tung mat cat
      (if (null stop)
        (progn
          (princ "\nDang nhan dien trac ngang...")
          (setq data (TNMB:collect ss cfg)
                raw (TNMB:raw-sections (car data) (cadr data)))
          (if (null raw)
            (setq stop (strcat "Khong thay duong tim trac ngang tren lop " (nth 2 cfg)
                               ". Kiem tra o 'Bang trac ngang' hoac chon ca bang ghi chu.")))))
      (if (null stop)
        (progn
          (setq texts (append (caddr data) (TNMB:all-texts cfg))
                groups (TNMB:group (TNMB:text-pairs texts raw) (length raw))
                cands nil)
          (foreach item (mapcar 'list raw groups)
            (if (setq st (TNMB:find-station (cadr item) (car item)))
              (setq cands (cons (list st (car item) (cadr item)) cands))
              (princ (strcat "\nBo qua 1 mat cat (tim X = " (rtos (car (car item)) 2 3)
                             ", Y = " (rtos (caddr (car item)) 2 3)
                             "): khong thay chu 'Km a + b' phia tren duong tim."))))
          ; Sap theo ly trinh; mat cat trung ly trinh (coc trung ten) chi lay 1.
          (setq cands (mapcar 'cddr (TNMB:ysort (TNMB:tag (mapcar '(lambda (x) (cons (car x) x))
                                                                 cands))))
                prev nil secs nil)
          (foreach c cands
            (if (and prev (equal (car c) prev 1e-6))
              (princ (strcat "\nBo 1 mat cat trung ly trinh " (TNMB:km-str (car c))
                             " (coc trung ten)."))
              (progn
                (setq item (cadr c) mss (TNMB:find-mss (caddr c) item))
                (if (null mss)
                  (setq mss (getreal (strcat "\nKhong thay MSS coc " (TNMB:km-str (car c))
                                             ", nhap MSS (Enter = bo coc): "))))
                (if mss
                  (setq secs (cons (list (car c) (nth 0 item) (nth 1 item) (nth 2 item)
                                         (nth 3 item) (nth 4 item) mss)
                                   secs)))))
            (setq prev (car c)))
          (setq secs (reverse secs))
          (if (null secs) (setq stop "Khong co mat cat hop le."))))
      ;; 3. Thanh phan tung mat cat
      (if (null stop)
        (progn
          (setq groups (TNMB:group (TNMB:assign (cadddr data) secs) (length secs)) sds nil)
          (foreach item (mapcar 'list secs groups)
            (setq sec (car item) comps nil)
            (foreach c (cadr item)
              (if (setq cp (TNMB:component (car c) (cadr c) sec ks))
                (setq comps (cons cp comps))))
            (if comps
              (setq sds (cons (list sec (reverse comps)) sds))
              (princ (strcat "\nCoc " (TNMB:km-str (car sec)) ": khong co duong tren lop "
                             (if ks (nth 5 cfg) (nth 4 cfg)) "."))))
          (setq sds (reverse sds))
          (if (null sds)
            (setq stop "Khong co thanh phan nao de trien khai.")
            (princ (strcat "\nNhan dien " (itoa (length sds)) " trac ngang.")))))
      ;; 4. Dinh vi mat bang
      (if (null stop)
        (if (= mode "THAT")
          (progn
            (setvar "OSMODE" (cdr (assoc "OSMODE" oldvars)))
            (while (and (null len)
                        (setq pick (VTL:pick "\nChon TIM TUYEN tren binh do (polyline/line/arc/spline), Enter = huy: ")))
              (if (setq len (TNMB:curve-len (car pick)))
                (setq align (car pick))
                (princ "\nKhong doc duoc duong nay (tim tuyen ADS can ADS dang chay). Hay chon polyline tim tuyen.")))
            (if (null align)
              (setq stop "Chua chon tim tuyen.")
              (progn
                ; Polyline khong co cung (vd 3D polyline tim cua ADS qua tam cac coc):
                ; tinh 2D, khop coc vao dinh. Co cung (tim tuyen that): dung truc tiep.
                (if (setq chord (TNMB:chord-verts align))
                  (progn
                    (setq chord (list chord (TNMB:cum chord)) len (last (cadr chord)))
                    (princ (strcat "\nTim tuyen gay khuc " (itoa (length (car chord)))
                                   " dinh: tinh 2D, khop tam coc vao dinh, mat cat vuong goc"
                                   " theo duong cong qua 3 dinh lien ke."))))
                (setq base (vlax-curve-getStartPoint align))
                (princ (strcat "\nTim tuyen dai " (rtos len 2 3) " m; diem dau polyline: X = "
                               (rtos (cadr base) 2 3) "  Y = " (rtos (car base) 2 3)
                               " (VN-2000: X la Bac, Y la Dong)."))
                ; Moc 1: diem da biet ly trinh tren tim tuyen (tam coc Km0+00, coc H...).
                ; Khong mac dinh diem dau polyline = Km0+00 (polyline co the dai hon tuyen).
                (setq m1 (TNMB:ask-mark align chord (strcat "\nPick DIEM MOC tren tim tuyen da biet ly trinh"
                                                      " (vd tam coc Km0+00), Enter = diem dau polyline: ")
                                        T)
                      dir 1.0)
                ; Moc 2 (tuy chon): phat hien polyline ve nguoc chieu / chieu dai khong khop.
                (setq m2 (TNMB:ask-mark align chord (strcat "\nPick DIEM MOC THU 2 de kiem tra (nen la coc cuoi tuyen),"
                                                      " Enter = bo qua: ")
                                        nil))
                (if (and m2 (> (abs (- (car m2) (car m1))) 1e-6))
                  (progn
                    (setq ratio (/ (- (cadr m2) (cadr m1)) (- (car m2) (car m1))))
                    (if (< ratio 0.0)
                      (progn
                        (setq dir -1.0)
                        (princ "\n(!) Polyline tim tuyen ve NGUOC chieu ly trinh: da tu dao chieu.")))
                    (if (> (abs (- (abs ratio) 1.0)) 0.002)
                      (princ (strcat "\n(!) Giua 2 moc: dai tren tim tuyen "
                                     (rtos (abs (- (car m2) (car m1))) 2 3) " m, chenh ly trinh "
                                     (rtos (abs (- (cadr m2) (cadr m1))) 2 3)
                                     " m -> KHONG KHOP. Kiem tra polyline tim tuyen va ly trinh moc."))
                      (princ "\nHai moc khop chieu dai tim tuyen."))))
                (setq pdata (list align (car m1) (cadr m1) dir len))
                (princ (strcat "\nTim tuyen phu ly trinh "
                               (TNMB:km-str (- (cadr m1) (* dir (car m1)))) " -> "
                               (TNMB:km-str (+ (cadr m1) (* dir (- len (car m1))))) ".")))))
          (progn
            (setvar "OSMODE" (cdr (assoc "OSMODE" oldvars)))
            (setq base (getpoint "\nPick diem dat mat bang (diem tim tuyen): "))
            (if (null base)
              (setq stop "Chua pick diem dat.")
              (progn
                (setq dirpt (getpoint base "\nPick diem chi huong tuyen <ngang sang phai>: ")
                      u (if dirpt
                          (VTL:unit (VTL:sub (trans dirpt 1 0) (trans base 1 0)))))
                (if (null u) (setq u '(1.0 0.0)))
                ; Ly trinh cua diem pick (mac dinh = coc dau tien duoc chon).
                (setq base (trans base 1 0)
                      pdata (list (list (car base) (cadr base)) u
                                  (TNMB:ask-st "\nLy trinh tai diem pick" (car (car (car sds)))))))))))
      ;; 5. Toa do mat bang
      (if (null stop)
        (progn
          (setvar "OSMODE" 0)
          (setq data nil)
          (if chord
            (setq chmap (TNMB:ch-map (mapcar '(lambda (x) (car (car x))) sds)
                                     (cadr chord) (car m1) (cadr m1) dir)))
          (foreach sd sds
            (setq sec (car sd)
                  frame (if chord
                          (TNMB:ch-frame (cdr (assoc (car sec) chmap)) (car chord) (cadr chord) dir len)
                          (TNMB:frame (car sec) mode pdata)))
            (if frame
              (progn
                (setq comps
                  (mapcar '(lambda (c)
                             (list (car c) (cadr c)
                                   (mapcar '(lambda (p)
                                              (append p (list (TNMB:plan frame (cadr p) (caddr p)))))
                                           (caddr c))))
                          (cadr sd)))
                (setq data (cons (list sec frame comps (TNMB:tim comps frame)) data)))
              (princ (strcat "\nBo qua coc " (TNMB:km-str (car sec))
                             ": nam ngoai chieu dai tim tuyen."))))
          (setq sds (reverse data))
          (if (null sds) (setq stop "Khong coc nao nam tren tim tuyen: kiem tra ly trinh diem dau."))))
      ;; 6. Layer rieng tung phan (chi tao phan duoc dung)
      (if (null stop)
        (progn
          ; Thu tu nhu *TNMB:PARTS*: ngang, doc, cao do, do doc, vach taluy, ten coc.
          (setq use (list T (= (nth 13 cfg) "1") (= (nth 24 cfg) "1")
                          (= (nth 14 cfg) "1")
                          (and (not ks) (= (nth 15 cfg) "1"))
                          (= (nth 25 cfg) "1"))
                layers nil ok T i 0)
          (foreach p *TNMB:PARTS*
            (if (and ok (nth i use))
              (if (setq lay (TNMB:prepare-layer (strcat (nth 7 cfg) (cadr p))
                                                (atoi (nth (caddr p) cfg))))
                (setq layers (cons (cons (cadddr p) lay) layers))
                (setq ok nil)))
            (setq i (1+ i)))
          (if (not ok) (setq stop "Layer ket qua chua san sang (xem thong bao o tren)."))))
      ;; 7. Ve
      (if (null stop)
        (progn
          (setq *TNMB:CTX*
            (append layers
              (list (cons '3d (= (nth 12 cfg) "3D"))
                    (cons 'h (* (atof (nth 9 cfg)) (atof (nth 11 cfg)) mm2cad))
                    (cons 'w (* (atof (nth 10 cfg)) (atof (nth 11 cfg)) mm2cad))
                    (cons 'style (TNMB:style (nth 8 cfg)))
                    (cons 'm2cad m2cad)
                    (cons 'slope (= (nth 14 cfg) "1"))
                    (cons 'caodo (= (nth 24 cfg) "1"))
                    (cons 'tencoc (= (nth 25 cfg) "1"))
                    (cons 'maugoc (= (nth 23 cfg) "1"))
                    (cons 'ltaluy (nth 6 cfg))
                    (cons 'step (* (atof (nth 16 cfg)) m2cad))))
                *TNMB:N-NGANG* 0 *TNMB:N-CHU* 0 *TNMB:N-DOC* 0 *TNMB:N-VACH* 0 n-doc 0)
          (princ (strcat "\nDang ve " (itoa (length sds)) " trac ngang..."))
          (foreach sd sds (TNMB:draw-section sd))
          (if (= (nth 13 cfg) "1") (setq n-doc (TNMB:longitudinal sds)))
          (if (and (not ks) (= (nth 15 cfg) "1"))
            (progn
              (setq prev nil)
              (foreach sd sds
                (if prev (TNMB:ticks prev sd))
                (setq prev sd))))
          (princ (strcat "\nTNMB xong: " (itoa (length sds)) " coc, "
                         (itoa *TNMB:N-NGANG*) " polyline ngang, "
                         (itoa n-doc) " polyline doc, "
                         (itoa *TNMB:N-CHU*) " cao do, "
                         (itoa *TNMB:N-DOC*) " do doc, "
                         (itoa *TNMB:N-VACH*) " vach taluy."))
          (princ "\nLayer: ")
          (foreach p (reverse layers) (princ (strcat (cdr p) "  ")))
          ; Kiem tra ly trinh: vi tri tim coc dau / cuoi va khoang cach doc tuyen.
          (setq sdf (car sds) sdl (last sds))
          (princ (strcat "\nKiem tra: tim " (TNMB:km-str (car (car sdf))) " tai X = "
                         (rtos (cadr (car (cadr sdf))) 2 3) " Y = " (rtos (car (car (cadr sdf))) 2 3)
                         "; tim " (TNMB:km-str (car (car sdl))) " tai X = "
                         (rtos (cadr (car (cadr sdl))) 2 3) " Y = " (rtos (car (car (cadr sdl))) 2 3)
                         "; cach nhau theo tuyen " (rtos (- (car (car sdl)) (car (car sdf))) 2 2) " m."))
          (if (>= *TNMB:N-VACH* 1000000)
            (princ "\n(!) Dat gioi han 1000000 vach taluy: tang buoc vach."))
          (setq *TNMB:CTX* nil)))
      (if stop (princ (strcat "\nTNMB dung: " stop)))))
  (*error* nil))

; Go TNMB: mo hop thoai VTL voi chuc nang trien khai trac ngang chon san.
(defun C:TNMB ()
  (setq *VTL:FN* "TNMB")
  (C:VTL))

(princ (strcat "\nDa nap VTL.lsp [" *VTL:BUILD* "]. Go VTL: ve taluy binh do"
               " / trien khai trac ngang thanh mat bang (chung 1 hop thoai)."))
(princ)
