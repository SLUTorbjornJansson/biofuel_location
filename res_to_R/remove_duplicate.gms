parameter largest_%1(g,*);
parameter small%1(b_fuel,tech,i,g,*);
parameter initial%1;
parameter end%1;
parameter duplicate%1(g, *);



initial%1 = sum((b_fuel,tech,i,g,%2), p_%1(b_fuel,tech,i,g,%2));

* remove small or negative flows
p_%1(b_fuel,tech,i,g,%2) $ (p_%1(b_fuel,tech,i,g,%2) < 0.01) = 0;

* find largest_%1 feedstock flow
largest_%1(g, %2) = smax((b_fuel,tech,ii), p_%1(b_fuel,tech,ii,g,%2));

*parameter summan2(b_fuel, tech, g,%2);
*summan2(b_fuel, tech, g,%2) $ (sum(i, p_%1(b_fuel,tech,i,g,%2))>0)= sum(i$(p_%1(b_fuel,tech,i,g,%2)=largest_%1(b_fuel,tech,g,%2)), 1);

* Find flows small%1er than largest_%1 flow
small%1(b_fuel,tech,i,g,%2) $ (p_%1(b_fuel,tech,i,g,%2)< largest_%1(g, %2))= p_%1(b_fuel,tech,i,g,%2);

alias(b_fuel,b_fuel2);
alias(tech, tech2);
alias(%2,%2_2);

* set small%1 flows to zero
p_%1(b_fuel,tech,i,g,%2) $ (p_%1(b_fuel,tech,i,g,%2)< largest_%1(g, %2)) =0;

* if duplicate (equal) entries, chose random
loop((b_fuel,tech,i),
    p_%1(b_fuel,tech,i,g,%2) $ [p_%1(b_fuel,tech,i,g,%2) < smax((b_fuel2,tech2,ii), p_%1(b_fuel2,tech2,ii,g,%2) )] =0;
    p_%1(b_fuel,tech,i,g,%2)$p_%1(b_fuel,tech,i,g,%2) = sum((b_fuel2,tech2,ii), p_%1(b_fuel2,tech2,ii,g,%2));
);


* add small%1 feedstock flow to facility i with largest_%1 flow from g

p_%1(b_fuel,tech,i,g,%2) =
    p_%1(b_fuel,tech,i,g,%2) + sum((b_fuel2,tech2,ii), small%1(b_fuel2,tech2,ii,g,%2)); 


*display p_%1;
*summan(b_fuel, tech, g,%2) =sum(i$p_%1(b_fuel,tech,i,g,%2),1 );

*abort $ (sum(i$p_%1("ethanol","low",i,"114","grass1"),1) >1)  'dublicate entries of feedstock';

* Abort if dulicate entry exist
* remove all duplicates if smaller than 0.1;


duplicate%1(g, %2) $ (sum((i,b_fuel, tech)$p_%1(b_fuel,tech,i,g,%2), 1) >1) =sum((i,b_fuel, tech)$p_%1(b_fuel,tech,i,g,%2), 1);




loop ((g, %2),

    abort $ (sum((i,b_fuel, tech)$p_%1(b_fuel,tech,i,g,%2), 1) >1)  'duplicate entries of feedstock %resultfile%',  duplicate%1;

);

end%1 =  sum((b_fuel,tech,i,g,%2), p_%1(b_fuel,tech,i,g,%2));

display initial%1, end%1, duplicate%1;

option kill = largest_%1;
option kill = small%1;
option kill = initial%1;
option kill = end%1;
option kill =duplicate%1;

* --- for sum
*--------------------------------------
parameter largest_%1%3(g,*);
parameter small%1%3(b_fuel,tech,i,g,*);
parameter initial%1%3;
parameter end%1%3;
parameter duplicate%1%3(g);


initial%1%3 = sum((b_fuel,tech,i,g), p_%1(b_fuel,tech,i,g,'%4'));

* remove any small or negative flows
p_%1(b_fuel,tech,i,g,'%4') $ (p_%1(b_fuel,tech,i,g,'%4') < 0.01)= 0;


* find largest_%1 feedstock flow
largest_%1%3(g, '%4') = smax((b_fuel,tech,i), p_%1(b_fuel,tech,i,g,'%4'));

*parameter summan2(b_fuel, tech, g,%2);
*summan2(b_fuel, tech, g,%2) $ (sum(i, p_%1(b_fuel,tech,i,g,%2))>0)= sum(i$(p_%1(b_fuel,tech,i,g,%2)=largest_%1(b_fuel,tech,g,%2)), 1);

* Find flows small%1er than largest_%1 flow
small%1%3(b_fuel,tech,i,g,'%4') $ (p_%1(b_fuel,tech,i,g,'%4')< largest_%1(g, '%4'))= p_%1(b_fuel,tech,i,g,'%4');

* set small%1 flows to zero
p_%1(b_fuel,tech,i,g,'%4') $ (p_%1(b_fuel,tech,i,g,'%4')< largest_%1(g, '%4')) =0;



* if duplicate (equal) entries, chose (of these) random region i, b_fuel and tech to get feedstock flow
loop((b_fuel,tech,i),
    p_%1(b_fuel,tech,i,g,'%4') $ [p_%1(b_fuel,tech,i,g,'%4') < smax((b_fuel2,tech2,ii), p_%1(b_fuel2,tech2,ii,g,'%4') )] =0;
    p_%1(b_fuel,tech,i,g,'%4')$p_%1(b_fuel,tech,i,g,'%4') = sum((b_fuel2,tech2,ii), p_%1(b_fuel2,tech2,ii,g,'%4'));
);


* add small%1 feedstock flow to facility i with largest_%1 flow from g

p_%1(b_fuel,tech,i,g,'%4') =
    p_%1(b_fuel,tech,i,g,'%4') + sum((b_fuel2,tech2,ii), small%1%3(b_fuel2,tech2,ii,g,'%4')); 







    



duplicate%1%3(g) $ (sum((i,b_fuel, tech)$p_%1(b_fuel,tech,i,g,'%4'), 1) >1) =sum((i,b_fuel, tech) $ p_%1(b_fuel,tech,i,g,'%4'), 1);

display p_%1;


loop (g,

    abort $ (sum((i,b_fuel, tech)$p_%1(b_fuel,tech,i,g,'%4'), 1) >1)  'duplicate entries of feedstock %resultfile%',  duplicate%1%3;

);


end%1%3 =  sum((b_fuel,tech,i,g), p_%1(b_fuel,tech,i,g,'%4'));

display initial%1%3, end%1%3, duplicate%1%3;

option kill = largest_%1%3;
option kill = small%1%3;
option kill = initial%1%3;
option kill = end%1%3;
option kill = duplicate%1%3;