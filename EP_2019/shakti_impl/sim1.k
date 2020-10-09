gr:{[w;f;sc;n] n:+/ sc>n?1.0;[[]dd:-1;w:2+n?w;f:1+n?f;s:`pend]};
distinct:{(!#x) in x[`i]?x[`i]};
step:{[ma;d;r]
 fd:(r[`dd]&`prog=r`s) _ d;r:r,'(+1++`t#r);
 ma-:+/`prog=r`s;r:{[ma;r]r[`i] in @[;`i]ma _ {(~x[`a]>x[`t])&(x[`s]=`pend)}#r}[ma;]_r;
 n:{[fd;x](#x)#+(+x),+([[]dd:fd;s:`prog;sr:x`t])}[fd]{x>!#y}[#fd]#{[x](~x[`a]>x`t)&`pend=x`s}#r;
 r:distinct#n,r;c:{+(+x),+([[]s:`cancel;c:x[`t]])}{(~x[`t]<x[`a]+x[`w])&`pend=x[`s]}#r;
 f:{+(+x),+([[]s:`finish;c:x[`t]])}{(~x[`t]<x[`a]+x[`f])&`prog=x[`s]}#r;
 distinct#f,c,r};
run:{[w;f;rt;sc;ma;nt] r:{[x][[]i:!#x],'x}(,/+'([[]a:!rt;c:-1;t:-1;sr:-1;d:-1],'+'gr[w;f;sc]'rt#ma));
  {x@<x}[(rt;step[ma;!nt])/:r]}
/run[2;3;10;0.2;10;3]
