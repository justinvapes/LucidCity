local isVisible = false
local tabletObject = nil
local citizenID = nil
local charges = {}
local fines = {
	[1] = {label = "Unlawful Imprisonment", jailtime = 20, amount = 2500},
	[2] = {label = "Accomplice of Unlawful Imprisonment", jailtime = 20, amount = 2500},
	[3] = {label = "Accessory of Unlawful Imprisonment", jailtime = 15, amount = 1750},
	[4] = {label = "Kidnapping", jailtime = 25, amount = 4000},
	[5] = {label = "Accomplice of Kidnapping", jailtime = 25, amount = 4000},
	[6] = {label = "Accessory of Kidnapping", jailtime = 20, amount = 3250},
	[7] = {label = "Kidnapping of a Government Employee", jailtime = 30, amount = 5000},
	[8] = {label = "Accomplice to Kidnapping of a Government Employee", jailtime = 30, amount = 5000},
	[9] = {label = "Accessory to Kidnapping of a Government Employee", jailtime = 25, amount = 3500},
	[10] = {label = "Assault with a Deadly Weapon", jailtime = 25, amount = 4500},	
	[11] = {label = "Accomplice to Assault with a Deadly Weapon", jailtime = 25, amount = 4500},	
	[12] = {label = "Accessory to Assault with a Deadly Weapon", jailtime = 20, amount = 3750},
	[13] = {label = "Manslaughter", jailtime = 30, amount = 5500},	
	[14] = {label = "Accomplice to Manslaughter", jailtime = 30, amount = 5500},	
	[15] = {label = "Accessory to Manslaughter", jailtime = 25, amount = 4750},	
	[16] = {label = "Attempted Second Degree Murder", jailtime = 30, amount = 6500},	
	[17] = {label = "Accomplice to Attempted Second Degree Murder", jailtime = 30, amount = 6500},	
	[18] = {label = "Accessory to Attempted Second Degree Murder", jailtime = 25, amount = 5500},	
	[19] = {label = "Second Degree Murder", jailtime = 40, amount = 7000},	
	[20] = {label = "Accomplice to Second Degree Murder", jailtime = 40, amount = 7000},	
	[21] = {label = "Accessory to Second Degree Murder", jailtime = 35, amount = 6000},	
	[22] = {label = "Attempted First Degree Murder", jailtime = 35, amount = 8500},	
	[23] = {label = "Accomplice to Attempted First Degree Murder", jailtime = 35, amount = 8500},	
	[24] = {label = "Accessory to Attempted First Degree Murder", jailtime = 30, amount = 7000},	
	[25] = {label = "First Degree Murder", jailtime = 50, amount = 9500},	
	[26] = {label = "Accomplice to First Degree Murder", jailtime = 50, amount = 9500},	
	[27] = {label = "Accessory to First Degree Murder", jailtime = 45, amount = 8500},	
	[28] = {label = "Attempted Murder of a Government Employee", jailtime = 45, amount = 11000},	
	[29] = {label = "Accomplice to Attempted Murder of A Government Employee", jailtime = 45, amount = 11000},	
	[30] = {label = "Accessory to Attempted Murder of a Government Employee", jailtime = 40, amount = 10000},	
	[31] = {label = "Murder of a Government Employee", jailtime = 55, amount = 12500},	
	[32] = {label = "Accomplice to Murder of a Government Employee", jailtime = 55, amount = 12500},	
	[33] = {label = "Accessory to Murder of a Government Employee", jailtime = 50, amount = 11750},	
	[34] = {label = "Gang Related Shooting", jailtime = 30, amount = 6500},	
	[35] = {label = "Accomplice to Gang Related Shooting", jailtime = 30, amount = 6500},	
	[36] = {label = "Accessory to Gang Related Shooting", jailtime = 20, amount = 5250},	
	[37] = {label = "Reckless Endangerment", jailtime = 20, amount = 3000},	
	[38] = {label = "Accomplice of Reckless Endangerment", jailtime = 20, amount = 3000},	
	[39] = {label = "Accessory of Reckless Endangerment", jailtime = 15, amount = 2500},	
	[40] = {label = "Assault & Battery", jailtime = 12, amount = 1500},	
	[41] = {label = "Accomplice to Assault & Battery", jailtime = 12, amount = 1500},	
	[42] = {label = "Accessory to Assault & Battery", jailtime = 10, amount = 1250},	
	[43] = {label = "Criminal Threats", jailtime = 10, amount = 3000},	
	[44] = {label = "Accomplice to Criminal Threats", jailtime = 10, amount = 3000},	
	[45] = {label = "Accessory to Criminal Threats", jailtime = 8, amount = 2500},	
	[46] = {label = "Brandishing of a Firearm", jailtime = 5, amount = 3250},
	[47] = {label = "Grand Theft Auto", jailtime = 20, amount = 2500},
	[48] = {label = "Accomplice to Grand Theft Auto", jailtime = 20, amount = 2500},	
	[49] = {label = "Accessory to Grand Theft Auto", jailtime = 15, amount = 2000},	
	[50] = {label = "Receiving Stolen Property in the First Degree", jailtime = 25, amount = 17500},	
	[51] = {label = "Robbery", jailtime = 20, amount = 5000},	
	[52] = {label = "Accomplice to Robbery", jailtime = 20, amount = 5000},	
	[53] = {label = "Accessory to Robbery", jailtime = 15, amount = 4000},	
	[54] = {label = "First Degree Robbery", jailtime = 45, amount = 15000},	
	[55] = {label = "Accomplice to First Degree Robbery", jailtime = 45, amount = 15000},	
	[56] = {label = "Accessory to First Degree Robbery", jailtime = 45, amount = 13500},	
	[57] = {label = "Possession of Stolen Goods", jailtime = 15, amount = 4000},	
	[58] = {label = "Grand Larceny", jailtime = 20, amount = 6500},	
	[59] = {label = "Accomplice to Grand Larceny", jailtime = 20, amount = 6500},	
	[60] = {label = "Accessory to Grand Larceny", jailtime = 15, amount = 5750},	
	[61] = {label = "Theft of a Government Issued Vehicle", jailtime = 35, amount = 12000},	
	[62] = {label = "Accomplice to Theft of a Government Issued Vehicle", jailtime = 35, amount = 12000},	
	[63] = {label = "Accessory to Theft of a Government Issued Vehicle", jailtime = 25, amount = 10000},	
	[64] = {label = "Possession of Dirty Money in the First Degree", jailtime = 20, amount = 15000},	
	[65] = {label = "Possession of Dirty Money in the Second Degree", jailtime = 10, amount = 6500},	
	[66] = {label = "Grand Theft", jailtime = 12, amount = 5500},	
	[67] = {label = "Accomplice to Grand Theft", jailtime = 12, amount = 5500},	
	[68] = {label = "Accessory to Grand Theft", jailtime = 8, amount = 5000},	
	[69] = {label = "Joyriding", jailtime = 10, amount = 1500},	
	[70] = {label = "Accomplice to Joyriding", jailtime = 10, amount = 1500},	
	[71] = {label = "Accessory to Joyriding", jailtime = 5, amount = 1250},	
	[72] = {label = "Tampering with a Vehicle", jailtime = 12, amount = 2000},	
	[73] = {label = "Accomplice to Tampering with a Vehicle", jailtime = 12, amount = 2000},	
	[74] = {label = "Accessory to Tampering with a Vehicle", jailtime = 6, amount = 1650},	
	[75] = {label = "Receiving Stolen Property in the Third Degree", jailtime = 0, amount = 3500},	
	[76] = {label = "Receiving Stolen Property in the Second Degree", jailtime = 10, amount = 6500},	
	[77] = {label = "Possession of a Stolen Identification Card", jailtime = 10, amount = 3000},
	[78] = {label = "Leaving without Paying", jailtime = 5, amount = 1500},	
	[79] = {label = "Accomplice to Leaving without Paying", jailtime = 5, amount = 1500},	
	[80] = {label = "Accessory to Leaving without Paying", jailtime = 0, amount = 1000},	
	[81] = {label = "Sale of Stolen Goods or Stolen Property", jailtime = 12, amount = 2500},	
	[82] = {label = "Accomplice to Sale of Stolen Goods or Stolen Property", jailtime = 12, amount = 2500},	
	[83] = {label = "Accessory to Sale of Stolen Goods or Stolen Property", jailtime = 10, amount = 2000},	
	[84] = {label = "Petty Theft", jailtime = 5, amount = 3000},	
	[85] = {label = "Accomplice to Petty Theft", jailtime = 5, amount = 3000},	
	[86] = {label = "Accessory to Petty Theft", jailtime = 0, amount = 2500},	
	[87] = {label = "Extortion", jailtime = 25, amount = 6000},	
	[88] = {label = "Accomplice to Extortion", jailtime = 25, amount = 6000},	
	[89] = {label = "Accessory to Extortion", jailtime = 15, amount = 5000},
	[90] = {label = "Fraud", jailtime = 20, amount = 7250},	
	[91] = {label = "Accomplice to Fraud", jailtime = 20, amount = 7250},	
	[92] = {label = "Accessory to Fraud", jailtime = 15, amount = 6500},	
	[93] = {label = "Impersonation", jailtime = 20, amount = 10000},	
	[94] = {label = "Accomplice to Impersonation", jailtime = 20, amount = 10000},	
	[95] = {label = "Accessory to Impersonation", jailtime = 15, amount = 8500},	
	[96] = {label = "Impersonation of a Law Enforcement Officer", jailtime = 60, amount = 13500},	
	[97] = {label = "Accomplice to Impersonation of a Law Enforcement Officer", jailtime = 50, amount = 13500},	
	[98] = {label = "Accessory to Impersonation of a Law Enforcement Officer", jailtime = 30, amount = 12000},	
	[99] = {label = "Impersonation of a Judge", jailtime = 60, amount = 20000},	
	[100] = {label = "Accomplice to Impersonation of a Judge", jailtime = 60, amount = 20000},	
	[101] = {label = "Accessory to Impersonation of a Judge", jailtime = 45, amount = 18250},	
	[102] = {label = "Impersonation of a Government Employee", jailtime = 30, amount = 12000},	
	[103] = {label = "Accomplice to Impersonation of a Government Employee", jailtime = 30, amount = 12000},	
	[104] = {label = "Accessory to Impersonation of a Government Employee", jailtime = 20, amount = 11000},	
	[105] = {label = "Vehicle Registration Fraud", jailtime = 15, amount = 6000},	
	[106] = {label = "Identity Theft", jailtime = 25, amount = 11000},	
	[108] = {label = "Accomplice to Identity Theft", jailtime = 25, amount = 11000},
	[109] = {label = "Accessory to Identity Theft", jailtime = 15, amount = 10000},	
	[110] = {label = "Witness Tampering", jailtime = 25, amount = 20000},	
	[111] = {label = "Accomplice to Witness Tampering", jailtime = 25, amount = 20000},	
	[112] = {label = "Accessory to Witness Tampering", jailtime = 15, amount = 18000},	
	[113] = {label = "Burglary", jailtime = 20, amount = 6500},
	[114] = {label = "Accomplice to Burglarly", jailtime = 20, amount = 6500},	
	[115] = {label = "Accessory to Burglarly", jailtime = 12, amount = 5750},	
	[116] = {label = "Felony Trespassing", jailtime = 25, amount = 12500},	
	[117] = {label = "Accomplice to Felony Trespassing", jailtime = 25, amount = 12500},	
	[118] = {label = "Accessory to Felony Trespassing", jailtime = 20, amount = 10000},	
	[119] = {label = "Arson", jailtime = 40, amount = 22500},	
	[120] = {label = "Accomplice to Arson", jailtime = 40, amount = 22500},	
	[121] = {label = "Accessory to Arson", jailtime = 35, amount = 20000},	
	[122] = {label = "Trespassing", jailtime = 10, amount = 3500},	
	[123] = {label = "Accomplice to Trespassing", jailtime = 10, amount = 3500},	
	[124] = {label = "Accessory to Trespassing", jailtime = 0, amount = 2500},	
	[125] = {label = "Bribery", jailtime = 45, amount = 10000},	
	[126] = {label = "Accomplice to Bribery", jailtime = 45, amount = 10000},	
	[127] = {label = "Accessory to Bribery", jailtime = 40, amount = 8750},	
	[128] = {label = "Escaping Custody", jailtime = 50, amount = 6000},	
	[129] = {label = "Accomplice to Escaping Custody", jailtime = 50, amount = 6000},	
	[130] = {label = "Accessory to Escaping Custody", jailtime = 50, amount = 5000},	
	[131] = {label = "Prison Break", jailtime = 125, amount = 10000},	
	[132] = {label = "Accomplice to Prison Break", jailtime = 125, amount = 10000},	
	[133] = {label = "Accessory to Prison Break", jailtime = 85, amount = 8500},
	[134] = {label = "Perjury", jailtime = 35, amount = 7500},	
	[135] = {label = "Accomplice to Perjury", jailtime = 35, amount = 7500},	
	[136] = {label = "Accessory to Perjury", jailtime = 30, amount = 6750},	
	[137] = {label = "Violating a Court Order", jailtime = 35, amount = 7500},	
	[138] = {label = "Accomplice to Violating a Court Order", jailtime = 35, amount = 7500},	
	[139] = {label = "Accessory to Violating a Court Order", jailtime = 20, amount = 6250},	
	[140] = {label = "Embezzlement", jailtime = 75, amount = 20000},	
	[141] = {label = "Accomplice to Embezzlement", jailtime = 75, amount = 20000},	
	[142] = {label = "Accessory to Embezzlement", jailtime = 60, amount = 17500},	
	[143] = {label = "Attempted Prison Break", jailtime = 50, amount = 7500},	
	[144] = {label = "Accomplice to Attempted Prison Break", jailtime = 50, amount = 7500},	
	[145] = {label = "Accessory to Attempted Prison Break", jailtime = 50, amount = 6500},	
	[146] = {label = "Parole Violation", jailtime = 25, amount = 4000},	
	[147] = {label = "Introducing Contraband into a Government Facility", jailtime = 30, amount = 5500},	
	[148] = {label = "Accomplice to Introducing Contraband into a Government Facility", jailtime = 30, amount = 5500},	
	[149] = {label = "Accessory to Introducing Contraband into a Government Facility", jailtime = 15, amount = 5000},	
	[150] = {label = "Concealing an Escaped Prisoner", jailtime = 25, amount = 5000},	
	[151] = {label = "Contempt of Court", jailtime = 10, amount = 3000},	
	[152] = {label = "Accomplice to Contempt of Court", jailtime = 10, amount = 3000},	
	[153] = {label = "Accessory to Contempt of Court", jailtime = 5, amount = 2500},
	[154] = {label = "Failure to Appear", jailtime = 12, amount = 4500},	
	[155] = {label = "Accomplice to Failure to Appear", jailtime = 12, amount = 4500},	
	[156] = {label = "Accessory to Failure to Appear", jailtime = 8, amount = 4000},	
	[157] = {label = "Unauthorized Practice of Law", jailtime = 12, amount = 12000},	
	[158] = {label = "Accomplice to Unauthorized Practice of Law", jailtime = 12, amount = 12000},	
	[159] = {label = "Accessory to Unauthorized Practice of Law", jailtime = 10, amount = 10000},	
	[160] = {label = "Conspiracy", jailtime = 12, amount = 3500},	
	[161] = {label = "Accomplice to Conspiracy", jailtime = 12, amount = 3500},	
	[162] = {label = "Accessory to Conspiracy", jailtime = 12, amount = 3000},	
	[163] = {label = "Misuse of the 911 system", jailtime = 10, amount = 2500},	
	[164] = {label = "Riot", jailtime = 150, amount = 100000},
	[165] = {label = "Accomplice to Riot", jailtime = 150, amount = 100000},
	[166] = {label = "Accessory to Riot", jailtime = 150, amount = 85000},
	[167] = {label = "Disruption of a Public Utility", jailtime = 45, amount = 45000},
	[168] = {label = "Accomplice to Disruption of a Public Utility", jailtime = 45, amount = 45000},
	[169] = {label = "Accessory to Disruption of a Public Utility", jailtime = 35, amount = 40000},
	[170] = {label = "Felony Obstruction of Justice", jailtime = 30, amount = 13500},
	[171] = {label = "Accomplice to Felony Obstruction of Justice", jailtime = 30, amount = 13500},
	[172] = {label = "Accessory to Felony Obstruction of Justice", jailtime = 25, amount = 12000},
	[173] = {label = "Disobeying a Peace Officer", jailtime = 12, amount = 4000},
	[174] = {label = "Accomplice to Disobeying a Peace Officer", jailtime = 12, amount = 4000},
	[175] = {label = "Accessory to Disobeying a Peace Officer", jailtime = 10, amount = 3500},
	[176] = {label = "Disorderly Conduct", jailtime = 0, amount = 1500},
	[177] = {label = "Accomplice to Disorderly Conduct", jailtime = 0, amount = 1500},
	[178] = {label = "Accessory to Disorderly Conduct", jailtime = 0, amount = 1250},
	[179] = {label = "Disturbing the Peace", jailtime = 5, amount = 1250},
	[180] = {label = "Accomplice to Disturbing the Peace", jailtime = 5, amount = 1250},
	[181] = {label = "Accessory to Disturbing the Peace", jailtime = 0, amount = 1000},
	[182] = {label = "False Reporting", jailtime = 8, amount = 4000},
	[183] = {label = "Accomplice to False Reporting", jailtime = 8, amount = 4000},
	[184] = {label = "Accessory to False Reporting", jailtime = 5, amount = 3000},
	[185] = {label = "Harassment", jailtime = 12, amount = 2500},
	[186] = {label = "Accomplice to Harassment", jailtime = 12, amount = 2500},
	[187] = {label = "Accessory to Harassment", jailtime = 8, amount = 2000},
	[188] = {label = "Misdemeanor Obstruction of Justice", jailtime = 12, amount = 5500},
	[189] = {label = "Accomplice to Misdemeanor Obstruction of Justice", jailtime = 12, amount = 5500},
	[190] = {label = "Accessory to Misdemeanor Obstruction of Justice", jailtime = 12, amount = 4750},
	[191] = {label = "Tampering of Evidence", jailtime = 12, amount = 10000},
	[192] = {label = "Accomplice to Tampering of Evidence", jailtime = 12, amount = 10000},
	[193] = {label = "Accessory to Tampering of Evidence", jailtime = 12, amount = 8500},
	[194] = {label = "Vandalism of Government Property", jailtime = 10, amount = 4000},
	[195] = {label = "Accomplice to Vandalism of Government Property", jailtime = 10, amount = 4000},
	[196] = {label = "Accessory to Vandalism of Government Property", jailtime = 6, amount = 3500},
	[197] = {label = "Stalking", jailtime = 8, amount = 2000},
	[198] = {label = "Accomplice to Stalking", jailtime = 8, amount = 2000},
	[199] = {label = "Accessory to Stalking", jailtime = 5, amount = 1750},
	[200] = {label = "Animal Cruelty", jailtime = 5, amount = 1250},
	[201] = {label = "Accomplice to Animal Cruelty", jailtime = 5, amount = 1250},
	[202] = {label = "Accessory to Animal Cruelty", jailtime = 0, amount = 1000},
	[203] = {label = "Vandalism", jailtime = 0, amount = 2500},
	[204] = {label = "Accomplice to Vandalism", jailtime = 0, amount = 2500},
	[205] = {label = "Accessory to Vandalism", jailtime = 0, amount = 2250},
	[206] = {label = "Loitering", jailtime = 0, amount = 1250},
	[207] = {label = "Accomplice to Loitering", jailtime = 0, amount = 1250},
	[208] = {label = "Accessory to Loitering", jailtime = 0, amount = 1000},
	[209] = {label = "Sale of a Class 1 Narcotic", jailtime = 20, amount = 7500},
	[210] = {label = "Accomplice to Sale of a Class 1 Narcotic", jailtime = 20, amount = 7500},
	[211] = {label = "Accessory to Sale of a Class 1 Narcotic", jailtime = 15, amount = 6750},
	[212] = {label = "Sale of a Class 2 Narcotic", jailtime = 35, amount = 15000},
	[213] = {label = "Accomplice to Sale of a Class 2 Narcotic", jailtime = 35, amount = 15000},
	[214] = {label = "Accessory to Sale of a Class 2 Narcotic", jailtime = 30, amount = 13500},
	[215] = {label = "Felony Possession of a Class 1 Narcotic", jailtime = 35, amount = 5500},
	[216] = {label = "Felony Possession of a Class 2 Narcotic", jailtime = 40, amount = 10000},
	[217] = {label = "Felony Possession with Intent to Distribute", jailtime = 20, amount = 12500},
	[218] = {label = "Cultivation of Class 1 Narcotics", jailtime = 30, amount = 13500},
	[219] = {label = "Accomplice to Cultivation of Class 1 Narcotics", jailtime = 30, amount = 13500},
	[220] = {label = "Accessory to Cultivation of Class 1 Narcotics", jailtime = 20, amount = 12000},
	[221] = {label = "Cultivation of Class 2 Narcotics", jailtime = 45, amount = 17500},
	[222] = {label = "Accomplice to Cultivation of Class 2 Narcotics", jailtime = 45, amount = 17500},
	[223] = {label = "Accessory to Cultivation of Class 2 Narcotics", jailtime = 35, amount = 16000},
	[224] = {label = "Desecration of a Human Corpse", jailtime = 40, amount = 3000},
	[225] = {label = "Accomplice to Desecration of a Human Corpse", jailtime = 20, amount = 3000},
	[226] = {label = "Accessory to Desecration of a Human Corpse", jailtime = 15, amount = 2500},
	[227] = {label = "Trafficking of a Class 1 Narcotic", jailtime = 50, amount = 22500},
	[228] = {label = "Accomplice to Trafficking of a Class 1 Narcotic", jailtime = 50, amount = 22500},
	[229] = {label = "Accessory to Trafficking of a Class 1 Narcotic", jailtime = 40, amount = 20000},
	[230] = {label = "Trafficking of a Class 2 Narcotic", jailtime = 75, amount = 35000},
	[231] = {label = "Accomplice to Trafficking of a Class 2 Narcotic", jailtime = 75, amount = 35000},
	[232] = {label = "Accessory to Trafficking of a Class 2 Narcotic", jailtime = 60, amount = 30000},
	[233] = {label = "Human Trafficking", jailtime = 120, amount = 45000},
	[234] = {label = "Accomplice to Human Trafficking", jailtime = 120, amount = 45000},
	[235] = {label = "Accessory to Human Trafficking", jailtime = 100, amount = 40000},
	[236] = {label = "Prostitution", jailtime = 20, amount = 4500},
	[237] = {label = "Accomplice to Prostitution", jailtime = 20, amount = 4500},
	[238] = {label = "Accessory to Prostitution", jailtime = 15, amount = 4000},
	[239] = {label = "Misdemeanor Possession of a Class 1 Narcotic", jailtime = 10, amount = 3500},
	[240] = {label = "Misdemeanor Possession of a Class 2 Narcotic", jailtime = 12, amount = 5500},
	[241] = {label = "Public Indecency", jailtime = 8, amount = 3250},
	[242] = {label = "Practicing Medicine without a License", jailtime = 12, amount = 10000},
	[243] = {label = "Accomplice to Practicing Medicine without a License", jailtime = 12, amount = 10000},
	[244] = {label = "Accessory to Practicing Medicine without a License", jailtime = 10, amount = 8500},
	[245] = {label = "Littering", jailtime = 0, amount = 2000},
	[246] = {label = "Accomplice to Littering", jailtime = 0, amount = 2000},
	[247] = {label = "Accessory to Littering", jailtime = 0, amount = 1750},
	[248] = {label = "Public Intoxication", jailtime = 0, amount = 1500},
	[249] = {label = "Criminal Possession of a Class 2 Firearm", jailtime = 30, amount = 10000},
	[250] = {label = "Criminal Possession of a Class 3 Firearm", jailtime = 60, amount = 25000},
	[251] = {label = "Criminal Possession of a Government Issued Firearm", jailtime = 120, amount = 50000},
	[252] = {label = "Criminal Possession of a Outlawed Firearm", jailtime = 45, amount = 20000},
	[253] = {label = "Criminal Possession of Nerve Agents", jailtime = 180, amount = 100000},
	[254] = {label = "Criminal Possession of Explosives", jailtime = 200, amount = 125000},
	[255] = {label = "Criminal Sale of a Class 1 Firearm", jailtime = 40, amount = 12500},
	[256] = {label = "Accomplice to Criminal Sale of a Class 1 Firearm", jailtime = 40, amount = 12500},
	[257] = {label = "Accessory to Criminal Sale of a Class 1 Firearm", jailtime = 30, amount = 11000},
	[258] = {label = "Criminal Sale of a Class 2 Firearm", jailtime = 55, amount = 17500},
	[259] = {label = "Accomplice to Criminal Sale of a Class 2 Firearm", jailtime = 55, amount = 17500},
	[260] = {label = "Accessory to Criminal Sale of a Class 2 Firearm", jailtime = 45, amount = 16000},
	[261] = {label = "Criminal Sale of a Class 3 Firearm", jailtime = 75, amount = 30000},
	[262] = {label = "Accomplice to Criminal Sale of a Class 3 Firearm", jailtime = 75, amount = 30000},
	[263] = {label = "Accessory to Criminal Sale of a Class 3 Firearm", jailtime = 60, amount = 26500},
	[264] = {label = "Criminal Sale of Outlawed Firearms", jailtime = 65, amount = 22500},
	[265] = {label = "Accomplice to Criminal Sale of Outlawed Firearms", jailtime = 65, amount = 22500},
	[266] = {label = "Accessory to Criminal Sale of Outlawed Firearms", jailtime = 50, amount = 20000},
	[267] = {label = "Criminal Sale of Government Issued Firearms", jailtime = 85, amount = 50000},
	[268] = {label = "Accomplice to Criminal Sale of Government Issued Firearms", jailtime = 85, amount = 50000},
	[269] = {label = "Accessory to Criminal Sale of Government Issued Firearms", jailtime = 70, amount = 45000},
	[270] = {label = "Weapons Trafficking", jailtime = 125, amount = 60000},
	[271] = {label = "Accomplice to Weapons Trafficking", jailtime = 125, amount = 60000},
	[272] = {label = "Accessory to Weapons Trafficking", jailtime = 100, amount = 55000},
	[273] = {label = "Flying into Restricted Airspace", jailtime = 35, amount = 12500},
	[274] = {label = "Accomplice to Flying into Restricted Airspace", jailtime = 35, amount = 12500},
	[275] = {label = "Accessory to Flying into Restricted Airspace", jailtime = 25, amount = 11000},
	[276] = {label = "Piloting without a proper License", jailtime = 30, amount = 10000},
	[277] = {label = "Accomplice to Piloting without a proper License", jailtime = 30, amount = 10000},
	[278] = {label = "Accessory to Piloting without a proper License", jailtime = 20, amount = 8500},
	[279] = {label = "Possession of a Silencer / Suppressor", jailtime = 25, amount = 5000},
	[280] = {label = "Criminal use of Explosives", jailtime = 90, amount = 22500},
	[281] = {label = "Accomplice to Criminal use of Explosives", jailtime = 90, amount = 22500},
	[282] = {label = "Accessory to Criminal use of Explosives", jailtime = 75, amount = 20000},
	[283] = {label = "Criminal Possession of Government Issued Equipment", jailtime = 60, amount = 30000},
	[284] = {label = "Criminal Possession of a Class 1 Firearm", jailtime = 12, amount = 6500},
	[285] = {label = "Criminal Use of a Firearm", jailtime = 12, amount = 10000},
	[286] = {label = "Accomplice to Criminal Use of a Firearm", jailtime = 12, amount = 10000},
	[287] = {label = "Accessory to Criminal Use of a Firearm", jailtime = 10, amount = 8500},
	[288] = {label = "Brandishing non Firearm", jailtime = 10, amount = 5000},
	[289] = {label = "Accomplice to Brandishing non Firearm", jailtime = 10, amount = 5000},
	[290] = {label = "Accessory to Brandishing non Firearm", jailtime = 8, amount = 4000},
	[291] = {label = "Resisting Arrest", jailtime = 12, amount = 3000},
	[292] = {label = "Accomplice to Resisting Arrest", jailtime = 12, amount = 3000},
	[293] = {label = "Accessory to Resisting Arrest", jailtime = 8, amount = 2500},
	[294] = {label = "Criminal Possession of a Tazer", jailtime = 10, amount = 10000},
	[295] = {label = "Criminal Possession of a Government Issued Baton", jailtime = 10, amount = 6500},
	[296] = {label = "Window Tint ", jailtime = 0, amount = 2500},
	[297] = {label = "Jaywalking", jailtime = 0, amount = 1000},
	[298] = {label = "Felony Hit and Run", jailtime = 35, amount = 8500},
	[299] = {label = "Accomplice to Felony Hit and Run", jailtime = 35, amount = 8500},
	[300] = {label = "Accessory to Felony Hit and Run", jailtime = 25, amount = 7750},
	[301] = {label = "Reckless Evading", jailtime = 30, amount = 10000},
	[302] = {label = "Accomplice to Reckless Evasion", jailtime = 30, amount = 10000},
	[303] = {label = "Accessory to Reckless Evasion", jailtime = 20, amount = 8750},
	[304] = {label = "Reckless Driving", jailtime = 15, amount = 3000},
	[305] = {label = "Operating a motor vehicle on a suspended or revoked license", jailtime = 25, amount = 5000},
	[306] = {label = "Street Racing", jailtime = 50, amount = 13500},
	[307] = {label = "Accomplice to Street Racing", jailtime = 50, amount = 13500},
	[308] = {label = "Accessory to Street Racing", jailtime = 35, amount = 12000},
	[309] = {label = "Criminal Speeding", jailtime = 12, amount = 5000},
	[310] = {label = "Driving while intoxicated", jailtime = 12, amount = 4000},
	[311] = {label = "Hit and run", jailtime = 12, amount = 5000},
	[312] = {label = "Accomplice to Hit and Run", jailtime = 12, amount = 5000},
	[313] = {label = "Accessory to Hit and Run", jailtime = 8, amount = 4250},
	[314] = {label = "Evading", jailtime = 12, amount = 6000},
	[315] = {label = "Accomplice to Evasion", jailtime = 12, amount = 6000},
	[316] = {label = "Accessory to Evasion", jailtime = 10, amount = 5500},
	[317] = {label = "Unauthorized Operation of an Off-Road Vehicle", jailtime = 10, amount = 5500},
	[318] = {label = "Improper Window tint", jailtime = 5, amount = 2500},
	[319] = {label = "Failure to Yield to Emergency Vehicle", jailtime = 0, amount = 1750},
	[320] = {label = "Failure to Obey Traffic Control Devices", jailtime = 0, amount = 1250},
	[321] = {label = "Negligent Driving", jailtime = 0, amount = 2000},
	[322] = {label = "Fourth Degree Speeding", jailtime = 0, amount = 1000},
	[323] = {label = "Third Degree Speeding", jailtime = 0, amount = 1350},
	[324] = {label = "Second Degree Speeding", jailtime = 5, amount = 3000},
	[325] = {label = "First Degree Speeding", jailtime = 8, amount = 4000},
	[326] = {label = "Illegal Passing", jailtime = 0, amount = 1650},
	[327] = {label = "Driving on the Wrong Side of the Road", jailtime = 10, amount = 4500},
	[328] = {label = "Illegal Turn", jailtime = 0, amount = 2500},
	[329] = {label = "Failure to Stop", jailtime = 0, amount = 1500},
	[330] = {label = "Unauthorized Parking", jailtime = 0, amount = 1000},
	[331] = {label = "Riding on a Sidewalk", jailtime = 10, amount = 4000},
	[332] = {label = "Operating a Motor Vehicle Without Proper Identification", jailtime = 12, amount = 3000},
	[333] = {label = "Failure to Signal", jailtime = 0, amount = 1000},
	[334] = {label = "Attempted Second Degree Murder on a Peace Officer", jailtime = 45, amount = 10000},
	[335] = {label = "Accomplice to Attempted Second Degree Murder on a Peace Officer", jailtime = 45, amount = 10000},
	[336] = {label = "Accessory to Attempted Second Degree Murder on a Peace Officer", jailtime = 40, amount = 8000},
	[337] = {label = "Second Degree Murder on a Peace Officer", jailtime = 55, amount = 12500},
	[338] = {label = "Accomplice to Second Degree Murder on a Peace Officer", jailtime = 55, amount = 12500},
	[339] = {label = "Accessory to Second Degree Murder on a Peace Officer", jailtime = 50, amount = 11500},
	[340] = {label = "Attempted First Degree Murder on a Peace Officer", jailtime = 60, amount = 15000},
	[341] = {label = "Accomplice to Attempted First Degree Murder on a Peace Officer", jailtime = 60, amount = 15000},
	[342] = {label = "Accessory to Attempted First Degree Murder on a Peace Officer", jailtime = 55, amount = 13500},
	[343] = {label = "First Degree Murder on a Peace Officer", jailtime = 75, amount = 17500},
	[344] = {label = "Accomplice to First Degree Murder on a Peace Officer", jailtime = 75, amount = 17500},
	[345] = {label = "Accessory to First Degree Murder on a Peace Officer", jailtime = 70, amount = 15000},
	[346] = {label = "Kidnapping of a Peace Officer", jailtime = 45, amount = 10000},
	[347] = {label = "Accomplice to Kidnapping a Peace Officer", jailtime = 45, amount = 10000},
	[348] = {label = "Accessory to Kidnapping a Peace Officer", jailtime = 40, amount = 8250},
	[349] = {label = "Attempted Second Degree Murder of a Government Official", jailtime = 60, amount = 13250},
	[350] = {label = "Accomplice to Attempted Second Degree Murder of a Government Official", jailtime = 60, amount = 13250},
	[351] = {label = "Accessory to Attempted Second Degree Murder of a Government Official", jailtime = 55, amount = 12500},
	[352] = {label = "Second Degree Murder of a Government Official", jailtime = 70, amount = 16500},
	[353] = {label = "Accomplice to Second Degree Murder of a Government Official", jailtime = 70, amount = 16500},
	[354] = {label = "Accessory to Second Degree Murder of a Government Official", jailtime = 65, amount = 15000},
	[355] = {label = "Attempted First Degree Murder of a Government Official", jailtime = 65, amount = 18500},
	[356] = {label = "Accomplice to Attempted First Degree Murder of a Government Official", jailtime = 65, amount = 18500},
	[357] = {label = "Accessory to Attempted First Degree Murder of a Government Official", jailtime = 60, amount = 17250},
	[358] = {label = "First Degree Murder of a Government Official", jailtime = 85, amount = 20000},
	[359] = {label = "Accomplice to First Degree Murder of a Government Official", jailtime = 85, amount = 20000},
	[360] = {label = "Accessory to First Degree Murder of a Government Official", jailtime = 80, amount = 19000},
	[361] = {label = "Kidnapping of a Government Official", jailtime = 55, amount = 12500},
	[362] = {label = "Accomplice to Kidnapping a Government Official", jailtime = 55, amount = 12500},
	[363] = {label = "Accessory to Kidnapping a Government Official", jailtime = 50, amount = 11250},
	[364] = {label = "Terrorism", jailtime = 250, amount = 100000},
	[365] = {label = "Accomplice to Terrorism", jailtime = 250, amount = 100000},
	[366] = {label = "Accessory to Terrorism", jailtime = 200, amount = 85000},
}

scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)


RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
	playerData = scCore.Functions.GetPlayerData()
	local plyName = ""
	if playerData.charinfo ~= nil then
		if playerData.charinfo.firstname ~= nil and playerData.charinfo.lastname ~= nil then
			plyName = playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname
		end
	end
	for k, v in pairs(fines) do 
		fines[k].id = k
		table.insert(charges, fines[k])
	end
	SendNUIMessage({
		type = "offensesAndOfficerLoaded",
		offenses = charges,
		name = plyName,
		callsign = playerData.metadata["callsign"]
	}) 
end)

RegisterNetEvent('mdt:client:getCitizenID')
AddEventHandler('mdt:client:getCitizenID', function(_citizenID)
	citizenID = _citizenID
end)

RegisterNetEvent('mdt:client:JailPlayer')
AddEventHandler('mdt:client:JailPlayer', function(jailAmount, offender, fineAmount)
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)

        -- trigger event to get citizenid for closet person 
        TriggerServerEvent('mdt:server:getPlayer', playerId)
        Citizen.Wait(100)
       
        otherPlayer = citizenID.PlayerData.citizenid
        local time = jailAmount

        if otherPlayer == offender then
            if tonumber(time) > 0 then
                TriggerServerEvent("police:server:JailPlayer", playerId, tonumber(time))
                Citizen.Wait(100)
                if fineAmount > 0 then
                    TriggerServerEvent("police:server:BillPlayer", playerId, tonumber(fineAmount))		
                    Citizen.Wait(100)		
                end
            else
                scCore.Notification("Time must be higher than 0", "error")
            end
        else
             scCore.Notification("You're trying to send the wrong person to jail!", "error")
        end
    else
        scCore.Notification("No one nearby!", "error")
    end
end)

function GetClosestPlayer()
    local closestPlayers = scCore.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end


TriggerServerEvent("mdt:getOffensesAndOfficer")

RegisterNetEvent("mdt:toggleVisibilty")
AddEventHandler("mdt:toggleVisibilty", function(reports, warrants, officer, callsign)
    local playerPed = PlayerPedId()
    if not isVisible then
        local dict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
        RequestAnimDict(dict)
        if tabletObject == nil then
            tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
            AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        end
        while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
            TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
        end
    else
        DeleteEntity(tabletObject)
        ClearPedTasks(playerPed)
        tabletObject = nil
    end
    if #warrants == 0 then warrants = false end
    if #reports == 0 then reports = false end
    SendNUIMessage({
        type = "recentReportsAndWarrantsLoaded",
        reports = reports,
        warrants = warrants,
        officer = officer,
		callsign = callsign
    })
    ToggleGUI()
end)

RegisterNUICallback("close", function(data, cb)
    local playerPed = PlayerPedId()
    DeleteEntity(tabletObject)
    ClearPedTasks(playerPed)
    tabletObject = nil
    ToggleGUI(false)
    cb('ok')
end)

RegisterNUICallback("ReleaseVehicle", function(data)
    impoundCoords = {x = 447.7644, y = -975.1281, z = 25.699, h = 180.0},
    scCore.Functions.SpawnVehicle(data.vehicleModel, function(veh)
        scCore.TriggerServerCallback('lcrp-garages:server:GetVehicleProperties', function(properties)
            scCore.Functions.SetVehicleProperties(veh, properties)
            SetVehicleNumberPlateText(veh, data.vehiclePlate)
            SetEntityHeading(veh, impoundCoords.h)
            exports['LegacyFuel']:SetFuel(veh, 100)
			scCore.Notification("Vehicle released, plate: ".. data.vehiclePlate)
        end, data.vehiclePlate)
    end, {x = 447.7644, y = -975.1281, z = 25.699, h = 180.0}, true)
end)

RegisterNUICallback("performOffenderSearch", function(data, cb)
    TriggerServerEvent("mdt:performOffenderSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("performForensicsSearch", function(data, cb)
    TriggerServerEvent("mdt:performForensicsSearch", data.query)
    cb('ok')
end)


RegisterNUICallback("viewOffender", function(data, cb)
    TriggerServerEvent("mdt:getOffenderDetails", data.offender)
    cb('ok')
end)

RegisterNUICallback("saveOffenderChanges", function(data, cb)

    if not data.changes.convictions  then
        data.changes.convictions = 'No Priors'
    end

    TriggerServerEvent("mdt:saveOffenderChanges", data.id, data.changes.notes, data.changes.mugshot_url, data.changes.convictions, data.changes.convictions_removed, data.identifier)
    cb('ok')
end)

RegisterNUICallback("submitNewReport", function(data, cb)
    TriggerServerEvent("mdt:submitNewReport", data)
    cb('ok')
end)

RegisterNUICallback("performReportSearch", function(data, cb)
    TriggerServerEvent("mdt:performReportSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("getOffender", function(data, cb)
    TriggerServerEvent("mdt:getOffenderDetailsById", data.char_id)
    cb('ok')
end)

RegisterNUICallback("deleteReport", function(data, cb)
    TriggerServerEvent("mdt:deleteReport", data.id)
    cb('ok')
end)

RegisterNUICallback("saveReportChanges", function(data, cb)
    TriggerServerEvent("mdt:saveReportChanges", data)
    cb('ok')
end)

RegisterNUICallback("vehicleSearch", function(data, cb)
    TriggerServerEvent("mdt:performVehicleSearch", data.plate)
    cb('ok')
end)

RegisterNUICallback("getVehicle", function(data, cb)
    TriggerServerEvent("mdt:getVehicle", data.vehicle)
    cb('ok')
end)

RegisterNUICallback("getWarrants", function(data, cb)
    TriggerServerEvent("mdt:getWarrants")
    cb('ok')
end)

RegisterNUICallback("submitNewWarrant", function(data, cb)
    TriggerServerEvent("mdt:submitNewWarrant", data)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("mdt:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("mdt:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("getReport", function(data, cb)
    TriggerServerEvent("mdt:getReportDetailsById", data.id)
    cb('ok')
end)

RegisterNUICallback("sentencePlayer", function(data, cb)
    local players = {}
    for i = 0, 256 do
        if GetPlayerServerId(i) ~= 0 then
            table.insert(players, GetPlayerServerId(i))
        end
    end
    TriggerServerEvent("mdt:sentencePlayer", data.jailtime, data.charges, data.char_id, data.fine, players)
    cb('ok')
end)

RegisterNetEvent('mdt:client:JailCommand')
AddEventHandler('mdt:client:JailCommand', function(playerId, time)
    TriggerServerEvent("police:server:JailPlayer", playerId, tonumber(time))
end)

RegisterNetEvent("mdt:returnOffenderSearchResults")
AddEventHandler("mdt:returnOffenderSearchResults", function(results)
    SendNUIMessage({
        type = "returnedPersonMatches",
        matches = results
    })
end)

RegisterNetEvent("mdt:returnOffenderDetails")
AddEventHandler("mdt:returnOffenderDetails", function(data)
    SendNUIMessage({
        type = "returnedOffenderDetails",
        details = data
    })
end)

RegisterNetEvent("mdt:returnReportSearchResults")
AddEventHandler("mdt:returnReportSearchResults", function(results)
    SendNUIMessage({
        type = "returnedReportMatches",
        matches = results
    })
end)

RegisterNetEvent("mdt:returnVehicleSearchInFront")
AddEventHandler("mdt:returnVehicleSearchInFront", function(results, plate)
    SendNUIMessage({
        type = "returnedVehicleMatchesInFront",
        matches = results,
        plate = plate
    })
end)

RegisterNetEvent("mdt:returnVehicleSearchResults")
AddEventHandler("mdt:returnVehicleSearchResults", function(results)
    SendNUIMessage({
        type = "returnedVehicleMatches",
        matches = results
    })
end)

RegisterNetEvent("mdt:returnVehicleDetails")
AddEventHandler("mdt:returnVehicleDetails", function(data)
    vehName = GetDisplayNameFromVehicleModel(data.model)
    data.model = GetLabelText(vehName)
    SendNUIMessage({
        type = "returnedVehicleDetails",
        details = data
    })
end)

RegisterNetEvent("mdt:returnWarrants")
AddEventHandler("mdt:returnWarrants", function(data)
    SendNUIMessage({
        type = "returnedWarrants",
        warrants = data
    })
end)

RegisterNetEvent("mdt:completedWarrantAction")
AddEventHandler("mdt:completedWarrantAction", function(data)
    SendNUIMessage({
        type = "completedWarrantAction"
    })
end)

RegisterNetEvent("mdt:returnReportDetails")
AddEventHandler("mdt:returnReportDetails", function(data)
    SendNUIMessage({
        type = "returnedReportDetails",
        details = data
    })
end)

function ToggleGUI(explicit_status)
  if explicit_status ~= nil then
    isVisible = explicit_status
  else
    isVisible = not isVisible
  end
  SetNuiFocus(isVisible, isVisible)
  SendNUIMessage({
    type = "enable",
    isVisible = isVisible
  })
end

function getVehicleInFront()
    local playerPed = PlayerPedId()
    local coordA = GetEntityCoords(playerPed, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 10.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

RegisterCommand("control_mdt", function(source)
	TriggerEvent("menu:menuexit")
    Citizen.Wait(500)
    TriggerServerEvent("mdt:openMDT", source)
end)