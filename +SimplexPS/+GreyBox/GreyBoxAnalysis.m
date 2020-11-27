%Greybox approach for participation analysis.
% Author(s): Yue Zhu
%%
% Before running this program, you need to config the analysis from
% GreyboxConfig.xlsx, which should be located in the toolbox root folder.
% Note1: device numbering keeps the same as bus numbering. For example: the device
% on bus7 will always be named as Device7.
% Note2: The final results will be saved in GbLayer1, GbLayer2, GbLayer3,
% GbMode and GbResidue.


%%
%Basic infomation acquirement.
BodeEnable = 0;
Layer12Enable = 0;
Layer3Enable = 1;
DeviceSelL12 = [1,2,3,6,8,11,12,13]; %Level1 & 2 device selection
DeviceSelL3All = [3,12]; %Level 3 device selection
ModeSelAll = [62,74]; % Mode selection.
AxisSel = [1, 4];  %axis selection for bodeplot.
ModeSelNum = length(ModeSelAll);

%get ResidueAll, ZmValAll.
[GbMode,ResidueAll,ZmValAll,ModeTotalNum] = SimplexPS.GreyBox.SSCal...
    (GminSS, N_Bus, DeviceType, ModeSelAll, GmDSS_Cell);

%%
%Analysis.
if BodeEnable ==1
SimplexPS.GreyBox.BodeDraw(DeviceSelL12, AxisSel, GminSS, DeviceType, N_Bus);
end

for modei=1:ModeSelNum
    Residue = ResidueAll{modei};
    ZmVal = ZmValAll{modei};
    FreqSel = imag(GbMode(ModeSelAll(modei)));
    if Layer12Enable ==1
    [Layer1, Layer2] = SimplexPS.GreyBox.GbLayer12(Residue,ZmVal,N_Bus,...
        DeviceType,modei,DeviceSelL12,FreqSel);
    GbLayer1{modei}=Layer1;
    GbLayer2{modei}=Layer2;
    end
    if Layer3Enable ==1
    GbLayer3{modei} = SimplexPS.GreyBox.GbLayer3(Residue,ZmVal,...
        FreqSel,DeviceType,DeviceSelL3All,Para,PowerFlow,Ts);
    end
end





% for modei=1:ModeSelNum % loop of mode.
%     ModeSel = ModeSelAll(modei);
%     FreqSel=imag(GbMode(Mode)); 
%     [Layer1Result, Layer2Result] = SimplexPS.GreyBox.Layer12(DeviceSel,...
%      DeviceType, N_Bus, GmDSS_Cell, GbMode, Mode, FreqSel, modei, Phi, Psi);
% end

% %% Bode, Layer1&2
% % Read Layer1&2 configureations.
% [AxisSel, DeviceSel, ModeSel] = SimplexPS.GreyBox.ExcelReadLayer12...
%     ('GreyBoxConfig.xlsx', N_Bus, DeviceType, GminSS);
% %draw bodeplot.
% SimplexPS.GreyBox.BodeDraw(DeviceSel, AxisSel, GminSS, DeviceType, N_Bus);
% %do layer 1&2 analysis;
% [Layer1Result, Layer2Result] = SimplexPS.GreyBox.Layer12(DeviceSel,GminSS,...
%     DeviceType, N_Bus, GmDSS_Cell, ModeSel);

%%
%Layer3

