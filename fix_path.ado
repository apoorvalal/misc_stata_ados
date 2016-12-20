pr fix_path, rclass
	// takes argument enclosed in double-quotes and returns local with unix path 
	// sometimes necessary with internal stata on windows, e.g. import excel, copy
	// safe to apply to all windows filepaths in caller   
	return loc fpath = "`=subinstr(`0',"\","/",.)'"
end
