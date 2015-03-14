classdef pTimesQPlots %< handle
    %pTimesQPlots Class for ...
    %   A detailed explanation would go here
    
    methods(Static)
        
        
        function [out]=makeFullChart(figHandle,dataStruct)
            whData=[dataStruct.impressions/10^9; dataStruct.revenue./dataStruct.impressions*1000];
            whData=whData';
            pTimesQPlots.createPQPlot(figHandle,whData,pTimesQPlots.colors );
            figure(figHandle);
            revData=whData(:,1).*whData(:,2);
            revData(isnan(revData))=0;
            titleText=sprintf('%s\n',dataStruct.name);
            if dataStruct.isNet
                titleText=sprintf('%sNet Revenue: $%.1fM\n',titleText,sum(revData,1));
                titleText=sprintf('%sImpressions: %.1fB\n',titleText,sum(whData(:,1),1));
                titleText=sprintf('%sNet eCPM: $%.2f',titleText,sum(revData,1)/sum(whData(:,1),1));
                myYLabel='Net eCPM';
            else
                titleText=sprintf('%sRevenue: $%.1fM \n',titleText,sum(revData,1));
                titleText=sprintf('%sImpressions: %.1fB\n',titleText,sum(whData(:,1),1));
                titleText=sprintf('%seCPM: $%.2f',titleText,sum(revData,1)/sum(whData(:,1),1));
                myYLabel='eCPM';
            end
            title(titleText);
            xlabel('impressions (billions)');
            ylabel(myYLabel);
            
            grid on;
            set(gca,'Position',[0.13 0.13375 0.775 0.7825]);
            legendLabels=pTimesQPlots.prepareLabels(whData,dataStruct.labels);
            pTimesQPlots.boxLegend(figHandle,pTimesQPlots.colors,legendLabels,0.085,{{'FontSize',14}});
            pTimesQPlots.trimAxes(figHandle,pTimesQPlots.getAxesLimits(whData));
            %set(gca,'YTick',ylab);
            %set(gca,'YTickLabel',sprintf('%3.2f\n',ylab));
            set(gca,'FontSize',14);
            set(gcf,'Position',[1 5 1440 800]);
            set(gcf,'PaperPositionMode','auto');
            out=1;
            
        end
        
        
        
        
        function [out]=getAxesLimits(whData)
            out=[sum(whData(:,1),1) max(whData(:,2),[],1)];
        end
        
        function [out]=trimAxes(fh,axesLimits)
            figure(fh);
            xlim([0,axesLimits(1)]);
            ylim([0,axesLimits(2)]);
            out=1;
        end
        
        function [out]=colors()
            
            %Colors for rectangles based on 2014b color palette
            out=[0    0.4470    0.7410;
                0.8500    0.3250    0.0980;
                0.9290    0.6940    0.1250;
                0.4940    0.1840    0.5560;
                0.4660    0.6740    0.1880;
                0.3010    0.7450    0.9330;
                0.6350    0.0780    0.1840];
        end
        
        function []=creatPQPlotWithLegend()
            
            
            
            
        end
        
        
        
        function [out] = createPQPlot(figHandle,whData,colors )
            %CREATEPQPLOT Summary of this function goes here
            %   Inputs
            %     figHandle:-Handle to the figure where the chart should eb
            %                created
            %     whData:----is a nx2 array. The first columns denotes
            %                the width of the 'n' rectangles, the second
            %                column denotes their height (P)
            figure(figHandle);
            numItems=size(whData,1);
            x=0; y=0;
            for i=1:numItems
                if whData(i,1)>0
                    rectangle('Position',[x,y,whData(i,1),whData(i,2)],...
                        'Curvature',[0,0],...
                        'FaceColor',colors(i,1:3),...
                        'LineStyle','none');
                    daspect('auto');
                end
                x=x+whData(i,1);
            end
            out=1;
        end
        
        function [thisLabels]=prepareLabels(whData,labels)
            %PREPARELABELS Summary of this function goes here
            %   Inputs
            %     whData: is a nx2 array. The first columns denotes
            %             the width of the 'n' rectangles, the second
            %             column denotes their height (P)
            %     labels: is a 1xn cell array with text categories
            numItems=size(labels,2);
            revData=whData(:,1).*whData(:,2);
            revData(isnan(revData))=0;
            thisLabels=cell([1 numItems]);
            for j=1:numItems
                thisRevenue=0;
                if whData(j,1)>0
                    thisRevenue=revData(j);
                    thisECPM=revData(j)/whData(j,1);
                    thisLabels{j}=strcat(labels{j},...
                        sprintf('\nRevenue: $%.1fM\n',thisRevenue));
                    thisLabels{j}=strcat(thisLabels{j},...
                        sprintf('\nImpressions: %.1fB\n',whData(j,1)) );
                    thisLabels{j}=strcat(thisLabels{j},...
                        sprintf('\neCPM: $%.2f\n',thisECPM) );
                else
                    thisLabels{j}=strcat(labels{j},...
                        sprintf('\nRevenue: $%.1fM\n',thisRevenue));
                    thisLabels{j}=strcat(thisLabels{j},...
                        sprintf('\nImpressions: %.1fB\n',whData(j,1)) );
                    thisLabels{j}=strcat(thisLabels{j},...
                        sprintf('\neCPM: N/A'));
                end
                
            end
        end
        
        function [out]=boxLegend(figHandle,colors,labels,boxheight,additionalProperties)
            out=0;
            numItems=size(labels,2);
            a=zeros([1 numItems]);
            figure(figHandle);
            for i=1:numItems
                a(i)=annotation('textbox', [(i-1)/numItems,0,1/numItems,boxheight],...
                    'String', labels{i},...
                    'BackgroundColor',colors(i,1:3),...
                    'LineStyle','none',...
                    'FontWeight','bold',...
                    'FontSize',10,...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','middle',...
                    'Color',[1 1 1]);
                %daspect([1,1,1]);
            end
            n=size(additionalProperties,1);
            if n>0
                for i=1:n
                    thisProp=additionalProperties{i};
                    for j=1:numItems
                        set(a(j),thisProp{1},thisProp{2});
                    end
                end
            end
            out=1;
        end
        
        function [fh]=timeBarCharts(revData,impData,years,catlabels,colors,additionalProperties)
            % Time based chart
            numPlots=size(revData,1);
            numItems=size(revData,2);
            eCPM=(sum(revData,2)./sum(impData,2))';
            fh=figure;
            subplot(3,1,1);
            %hold on;
            %set(gca,'Position',[0.13 0.41125 0.775 0.51375]);
            bar1=bar(1:numPlots,revData,0.5,'stack');
            ylim([0 max(sum(revData,2),[],1)]);
            grid on;
            set(gca, 'XTick', 1:numPlots);
            set(gca,'XTickLabel',years);
            n=size(additionalProperties,1);
            if n>0
                for i=1:n
                    thisProp=additionalProperties{i};
                    set(gca,thisProp{1},thisProp{2});
                end
            end
            % Add t title and axis labels
            title('Revenue by year')
            xlabel('Year')
            ylabel('Revenue ($ millions)')
            
            
            
            % Add a legend
            legend(catlabels,...
                'Location','southoutside',...
                'Box','off',...
                'Orientation','horizontal');%,...
            %'FontSize',14);
            
            
            subplot(3,1,2);
            bar2=bar(1:numPlots,impData,0.5,'stack');
            set(gca, 'XTick', 1:numPlots);
            set(gca,'XTickLabel',years);
            title('Impressions by year')
            xlabel('Year')
            ylabel('Impressions (billions)')
            % Additional properties
            ylim([0 max(sum(impData,2),[],1)]);
            grid on;
            if n>0
                for i=1:n
                    thisProp=additionalProperties{i};
                    set(gca,thisProp{1},thisProp{2});
                end
            end
            
            % use my colors
            for i=numItems:-1:1
                set(bar1(i),'FaceColor',colors(i,1:3));
                set(bar1(i),'LineStyle','none');
                set(bar2(i),'FaceColor',colors(i,1:3));
                set(bar2(i),'LineStyle','none');
            end
            
            subplot(3,1,3);
            bar3=bar(1:numPlots,eCPM,0.5);
            set(gca, 'XTick', 1:numPlots);
            set(gca,'XTickLabel',years);
            title('eCPM by year')
            xlabel('Year')
            ylabel('eCPM ($)')
            grid on;
            maxeCPM=max(eCPM,[],2);
            ylim([0 maxeCPM]);
            myYLabels=(0:floor(maxeCPM/0.25))*0.25;
            set(gca,'YTick',myYLabels);
            set(gca,'YTickLabel',sprintf('%3.2f\n',myYLabels));
            % Additional properties
            if n>0
                for i=1:n
                    thisProp=additionalProperties{i};
                    set(gca,thisProp{1},thisProp{2});
                end
            end
            
        end
        
    end
end
