
%%%%%%%%% Experimento 1

%LGR 1
%lgr = zpk([],[0 -1],2)

%LGR 2
%lgr = zpk([-2],[0 -1],2)

%LGR 3
%lgr = zpk([],[0 -1 -2],2)

%%%%%%%%% Experimento 2
%LGR 1
%lgr = zpk([],[-0.6-i*0.8 -0.6+i*0.8],1)

%LGR 2
%lgr = zpk([-3],[-0.6-i*0.8 -0.6+i*0.8],1)

%LGR 3
%lgr = zpk([],[-0.6-i*0.8 -0.6+i*0.8 -1],1)

%LGR 4
%lgr = zpk([-2 -4],[0 -1 -3],1)

%LGR 5
lgr = zpk([-2 -5],[-4 -1 -3],1)

rlocus(lgr)
sgrid;