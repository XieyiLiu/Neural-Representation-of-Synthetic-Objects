% Shared figure helper: Map negative angles to the interval [0, 2*pi].
function c2 = from0to2pi(rad)
c=rad2deg(rad);
c2 = deg2rad(mod(c,360));
