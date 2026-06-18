


class weapon;
    string name;
    function new(string name);
        this.name = name;
    endfunction

    virtual function void shot();
        $display("    [%s] ... (무기 없음)",name);
    endfunction


endclass

class m16 extends weapon;

    function new(string name);
        super.new(name);
        endfunction
    virtual function void shot();
        $display("   [%s] 탕탕탕   !!",name);  
    endfunction

endclass

class k2 extends weapon;

    function new(string name);
        super.new(name);
        endfunction
    virtual function void shot();
        $display("   [%s] 빵빵빵   !!",name);  
    endfunction

endclass

class aug extends weapon;

    function new(string name);
        super.new(name);
        endfunction
    virtual function void shot();
        $display("   [%s] 삐~~익~~~~   !!",name);  
    endfunction

endclass



module tb_weapon ();

initial begin
    weapon blackpink = new("no weapon");
    
    m16 m16 = new("m16");
    aug aug = new("aug");
    k2 k2 = new("k2");

    $display("====== 다형성 데모 ======");
    blackpink.shot();
    
    $display("====== 무기 M16으로 변경 ======");
    blackpink = m16;
    blackpink.shot();


    $display("====== 무기 aug으로 변경 ======");
    blackpink = aug;
    blackpink.shot();

    $display("====== 무기 k2으로 변경 ======");
    blackpink = k2;
    blackpink.shot();

    $finish;

end

endmodule