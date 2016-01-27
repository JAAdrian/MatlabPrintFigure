function [mOrigPosOut] = handleExtraSpace(self,mOrigPosIn)
%HANDLEEXTRASPACE <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
%
% Usage: [mOriginalPosition] = handleExtraSpace(self,mOriginalPosition)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  27-Jan-2016 19:40:18
% Updated:  <>
%

if nargin < 2 || isempty(mOrigPosIn),
    mOrigPosIn = nan;
end


numAxes     = length(self.AxesHandles);
mOrigPosOut = zeros(numAxes,4);
for aaAxes = 1:numAxes,
    szUnit = get(self.AxesHandles(aaAxes),'Units');
    set(self.AxesHandles(aaAxes),'Units','normalized');
    
    if all(isnan(mOrigPosIn)),
        vPosition = get(self.AxesHandles(aaAxes),'Position');
        
        set(self.AxesHandles(aaAxes),'Position',[...
            vPosition(1) + self.ExtraSpace(1),...
            vPosition(2) + self.ExtraSpace(2),...
            vPosition(3) + self.ExtraSpace(3),...
            vPosition(4) + self.ExtraSpace(4)...
            ]...
            );
        
        mOrigPosOut(aaAxes,:) = vPosition;
    else
        set(self.AxesHandles(aaAxes),'Position',mOrigPosIn(aaAxes,:));
    end
    
    set(self.AxesHandles(aaAxes),'Units',szUnit);
end




%-------------------- Licence ---------------------------------------------
% Copyright (c) 2016, J.-A. Adrian
% Institute for Hearing Technology and Audiology
% Jade University of Applied Sciences
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%	1. Redistributions of source code must retain the above copyright
%	   notice, this list of conditions and the following disclaimer.
%
%	2. Redistributions in binary form must reproduce the above copyright
%	   notice, this list of conditions and the following disclaimer in
%	   the documentation and/or other materials provided with the
%	   distribution.
%
%	3. Neither the name of the copyright holder nor the names of its
%	   contributors may be used to endorse or promote products derived
%	   from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
% TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
% HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
% TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% End of file: handleExtraSpace.m
