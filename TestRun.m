GAP = readtable('Yahoo_GAPS.csv');
A = gapLocate(GAP);
writetable(A,'gapAnalysis1.csv');

function [T] = gapLocate(ticker)
%
% Objective: Searches the table ticker for gaps in price > 1% and stores
%            the date in a vector.
%
% Input: ticker - Ticker symbol table
%
% Output: date - vector of index of gaps and gap %
%
    maxSize = height(ticker);
    gap = 0; % pre-initializing gap value
    j = 1; % indexing for date vector
    for i = 2:height(ticker)
        gap = (ticker.Open(i)-ticker.Close(i-1)) / ticker.Close(i-1) * 100;
        if gap >= 1
            SYMBOL(j,1) = ticker.Symbol(i);
            
            % Day 1 Data:
            hi = ticker.High(i);
            lo = ticker.Low(i);
            cl = ticker.Close(i);
            
            DATE(j,1) = ticker.Date(i);
            HIGH(j,1) = hi;
            LOW(j,1) = lo;
            CLOSE(j,1) = cl;
            VOLUME(j,1) = ticker.Volume(i);
            GAP_PCT(j,1) = gap;
            PCT_IN_RANGE(j,1) = percentInRange(hi,lo,cl);
            
            % Day 2 Data:
            hi2 = ticker.High(i+1);
            lo2 = ticker.Low(i+1);
            cl2 = ticker.Close(i+1);
            op2 = ticker.Open(i+1);
            
            D2_OPEN(j,1) = op2;
            D2_HIGH(j,1) = hi2;
            D2_LOW(j,1) = lo2;
            D2_CLOSE(j,1) = cl2;
            D2_VOL(j,1) = ticker.Volume(i+1);
            D2_PCT_IN_RANGE(j,1) = percentInRange(hi2,lo2,cl2);
            D2_GAP_PCT(j,1) = gapPercent2(op2,cl);
            D2_HI_PCT(j,1) = hiPercentage(hi2,op2);
            
            % Post 7 trading days After gap
            if ( i+7 < maxSize)
                postHi = max(ticker{i:i+7,"High"});
                WK1_HI_PCT(j,1) = hiPercentage(postHi,hi);
                if (ticker.Close(i+7)>cl)
                    priceMovement1 = "Up";
                elseif(ticker.Close(i+7)<cl)
                    priceMovement1 = "Down";
                elseif(ticker.Close(i+7)==cl)
                    priceMovement1 = "Flat";
                end
                WK1_MOMENTUM(j,1) = priceMovement1;
            else
                WK1_MOMENTUM(j,1) = " -  ";
                WK1_HI_PCT(j,1) = " -  ";
            end
            
            % Post 14 trading days After gap
            if ( i+14 < maxSize)
                postHi2 = max(ticker{i:i+14,"High"});
                WK2_HI_PCT(j,1) = hiPercentage(postHi2,hi);
                if (ticker.Close(i+14)>cl)
                    priceMovement2 = "Up";
                elseif(ticker.Close(i+14)<cl)
                    priceMovement2 = "Down";
                elseif(ticker.Close(i+14)==cl)
                    priceMovement2 = "Flat";
                end
                WK2_MOMENTUM(j,1) = priceMovement2;
            else
                WK2_MOMENTUM(j,1) = " -  ";
                WK2_HI_PCT(j,1) = " -  ";
            end
            
            j = j+1;
        end 
    end
    T = table(SYMBOL,DATE,HIGH,LOW,CLOSE,VOLUME,GAP_PCT,PCT_IN_RANGE,...
        D2_OPEN,D2_HIGH,D2_LOW,D2_CLOSE,D2_VOL,D2_GAP_PCT,...
        D2_PCT_IN_RANGE,D2_HI_PCT,WK1_HI_PCT,...
        WK1_MOMENTUM,WK2_HI_PCT,WK2_MOMENTUM);
end


function value = percentInRange(hi,lo,close)
%
% Objective: Calculates the position in range of the candle from LOD to
%            close. Used to determine overall strength of the close.
%
%            EQN: close - low / high - low
%
% Input: NA
%
% Output: value - percentage calculated
%
    value = (close-lo)/(hi-lo) * 100;
end

function value = hiPercentage(hi,open)
%
% Objective: Calculates percentage from open to high. Gives Day 2 range
%            for long play.
%
    value = (hi-open)/open * 100;
end

function value = gapPercent2(open,yestClose)
%
% Objective: Calulates percentage gap from Day 1 to 2
%
    value = (open - yestClose)/yestClose * 100;
end
