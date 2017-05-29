function [ out_img ] = apply_guided( guided, img )
% Warping function for guided filter

out_img = imguidedfilter(img, 'NeighborhoodSize', guided.neighbor, 'DegreeOfSmoothing', guided.smooth);

end

