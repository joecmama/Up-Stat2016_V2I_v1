function [DeltaHeading] = correctHeadingDiff(heading_after, heading_before)
% Calculate Theoretical Yawrate from Derivative (Physics) for a given ID.
%
% INPUT:
% - heading_after = Heading value for the later time point (t=t0+Delta_t)
% - heading_before = Heading value for the earlier time point (t=t0)
% OUTPUT:
% - DelatHeading: Modulo 360 deg corrected Heading Difference 
%   = corrected (Heading_after-Heading_before)
% ASSUMPTIONS:
% 1) Heading value is in degrees.

    % 0. Initial Preparation
    % 0.1. Rather than assuming, ensure all input Heading values are
    % [0..360] degrees:
    heading_after = mod(heading_after, 360); 
    heading_before = mod(heading_before, 360);
    
    % 1.0. First, obtain raw difference:
    DeltaHeading0 = (heading_after - heading_before);
    % 1.1. We want the result to be in [-180,+180]:
    % 1.1.1. If DeltaHeading0 > 180, then make it negative:
    if (DeltaHeading0 > 180)
        % 1.1.1.1. First ensure <= 360 
        DeltaHeading1 = mod( DeltaHeading0, 360 );
        % 1.1.1.2. Then change to negative value in [-180,0]
        DeltaHeading = mod( DeltaHeading1, -360 );
    % 1.1.2. If DeltaHeading0 < -180, then make positive:
    elseif (DeltaHeading0 < -180)
        % 1.1.2.1. First ensure >= -360 
        DeltaHeading1 = mod( DeltaHeading0, -360 );
        % 1.1.2.2. Then change to negative value in [0,180]
        DeltaHeading = mod( DeltaHeading1, 360 );        
    % 1.1.3. If |DeltaHeading0| <= 180: Do nothing.
    else
        DeltaHeading = DeltaHeading0;
    end

    
end % end function
