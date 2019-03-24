function ThemPoints = Get_Keypoints(Lowes)
% Takes Lowes Pyramid as input and finds Keypoints
% Lowes stored as
% Lowes{Blurs, i} where (Blurs+1)_th sigma, i is subsampling level
% Lowes{1,4} is Lowes image at scale sigma_0 and 8x smaller
ThemPoints = cell(size(Lowes,1),size(Lowes,2));
for Blurs = 2:size(Lowes,1)-1
    for i = 1:size(Lowes,2)
        for Patch_hor = 1:ceil(size(Lowes{1,i},1)./3)
            for Patch_vert = 1:ceil(size(Lowes{1,i},2)./3)
                for col=1:3
                    Patch_end_hor = Patch_hor*3;
                    Patch_end_vert = Patch_vert*3;
                    if (Patch_hor*3>size(Lowes{1,i},1))
                        Patch_end_hor = size(Lowes{1,i},1);
                    end
                    if (Patch_vert*3>size(Lowes{1,i},2))
                        Patch_end_vert = size(Lowes{1,i},2);
                    end
                    
                    max_above = max(max(Lowes{Blurs+1,i}...
                        (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col)));
                    max_curr = max(max(Lowes{Blurs,i}...
                        (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col)));
                    max_below = max(max(Lowes{Blurs-1,i}...
                        (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col)));
                    
                    % Maybe threshold?
                    [~, index] = max([max_above max_curr max_below]);
                    
                    if (index == 1)
                        [x, y] = find(Lowes{Blurs+1,i}...
                            (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col) ...
                            == max_above);
                        
                        if (length(x)>1)
                            continue;
                        end
                        
                        x = Patch_hor*3 - 3 + x;
                        y = Patch_vert*3 - 3 + y;
                        ThemPoints{Blurs+1,i} = [ThemPoints{Blurs+1,i}; x,y];
                    elseif (index == 2)
                        [x, y] = find(Lowes{Blurs,i}...
                            (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col) ...
                            == max_curr);
                        if (length(x)>1)
                            continue;
                        end
                        
                        x = Patch_hor*3 - 3 + x;
                        y = Patch_vert*3 - 3 + y;
                        ThemPoints{Blurs,i} = [ThemPoints{Blurs,i}; x,y];
                    else
                        [x,y] = find(Lowes{Blurs-1,i}...
                            (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col) ...
                            == max_below);
                        if (length(x)>1)
                            continue;
                        end
                        
                        x = Patch_hor*3 - 3 + x;
                        y = Patch_vert*3 - 3 + y;
                        ThemPoints{Blurs-1,i} = [ThemPoints{Blurs-1,i}; x,y];
                    end
                    
                    
                    min_above = min(min(Lowes{Blurs+1,i}...
                        (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col)));
                    min_curr = min(min(Lowes{Blurs,i}...
                        (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col)));
                    min_below = min(min(Lowes{Blurs-1,i}...
                        (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col)));
                    
                    % Maybe threshold?
                    [~, index] = min([min_above min_curr min_below]);
                    
                    if (index == 1)
                        [x, y] = find(Lowes{Blurs+1,i}...
                            (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col) ...
                            == min_above);
                        
                        if (length(x)>1)
                            continue;
                        end
                        
                        x = Patch_hor*3 - 3 + x;
                        y = Patch_vert*3 - 3 + y;
                        ThemPoints{Blurs+1,i} = [ThemPoints{Blurs+1,i}; x,y];
                    elseif (index == 2)
                        [x, y] = find(Lowes{Blurs,i}...
                            (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col) ...
                            == min_curr);
                        if (length(x)>1)
                            continue;
                        end
                        
                        x = Patch_hor*3 - 3 + x;
                        y = Patch_vert*3 - 3 + y;
                        ThemPoints{Blurs,i} = [ThemPoints{Blurs,i}; x,y];
                    else
                        [x,y] = find(Lowes{Blurs-1,i}...
                            (Patch_hor*3-2:Patch_end_hor,Patch_vert*3-2:Patch_end_vert,col) ...
                            == min_below);
                        if (length(x)>1)
                            continue;
                        end
                        
                        x = Patch_hor*3 - 3 + x;
                        y = Patch_vert*3 - 3 + y;
                        ThemPoints{Blurs-1,i} = [ThemPoints{Blurs-1,i}; x,y];
                    end
                    
                end
            end
        end
    end
end

for Blurs = 1:size(ThemPoints,1)
    for i = 1:size(ThemPoints,2)
        ThemPoints{Blurs,i} = unique(ThemPoints{Blurs,i},'rows');
    end
end



end

