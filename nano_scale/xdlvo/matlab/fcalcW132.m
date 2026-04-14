function cW132 = fcalcW132
global g1LW g2LW g3LW gammaAB
cW132=2*(sqrt(g1LW*g3LW)+sqrt(g2LW*g3LW)-sqrt(g1LW*g2LW)-g3LW)+gammaAB;
end