function repositories = stem_local_repositories
% Path to data repositories for BrainSTEM

repositories = {};
hostName = char(java.net.InetAddress.getLocalHost.getHostName); %system('hostname'); name = cellstr(name); name = name{1};
switch hostName
    case {'petermacbookpro.sb.nyumc.org','petermacbookpro.wireless.nyumc.org','peters-imac.skb.med.nyu.edu','Peters-MacBook-Pro.local','PeterMacBookPro.local','PeterMacBookPro','PeterMacBookPro.lan','PeterMacBookPro.local.tld','Peters-iMac.local'}
        % repositories.NYUshare_Datasets = '/Volumes/buzsakilab/Buzsakilabspace/Datasets';
        repositories.NYUshare_Peter = '/Volumes/buzsakilab/Homes/peterp03/IntanData';
        repositories.NYUshare_PeterNeuropixels = '/Volumes/buzsakilab/Homes/peterp03/NeuropixelsData';
        repositories.NYUshare_Peter_AmplipexData = '/Volumes/buzsakilab/Homes/peterp03/DataBank/AmplipexData';
        repositories.NYUshare_LabShare = '/Volumes/buzsakilab/Buzsakilabspace/LabShare';
        repositories.NYUshare_Viktor = '/Volumes/buzsakilab/Homes/vargav01/Analysis';
        repositories.NYUshare_Misi = '/Volumes/buzsakilab/Homes/voerom01/RF';
        repositories.NYUshare_Misi2 = '/Volumes/buzsakilab/Homes/voerom01/UM/Kyounghwan/Passive_probe';
        repositories.NYUshare_Manu = '/Volumes/buzsakilab/Homes/valerm05';
        repositories.AxoaxonicLabshare = '/Volumes/buzsakilab/Buzsakilabspace/LabShare/EnglishD/AxoAxo';
        repositories.NYUshare_PiriformCorticalRecordings = '/Volumes/Buzsakilab/Buzsakilabspace/LabShare/PeterPetersen/PiriformCorticalRecordings/';
        repositories.NYUshare_NickSteinmetz = '/Volumes/buzsakilab/Homes/peterp03/DataFromOthers/NickSteinmetz';
        repositories.NYUshare_AllenInstitute = '/Volumes/buzsakilab/Buzsakilabspace/Datasets/SiegleJ';
    case {'Peter','PeterSetup'}
        repositories.NYUshare_Peter = 'Z:\Homes\peterp03\IntanData';
        repositories.NYUshare_PeterNeuropixels = 'Z:\Homes\peterp03\NeuropixelsData';
        repositories.NYUshare_Datasets = 'Z:\Buzsakilabspace\Datasets';
        repositories.Peter_DataDrive1 = 'F:\IntanData';
        repositories.Peter_DataDrive2 = 'J:\IntanData';
        repositories.Peter_DataDrive3 = 'E:\IntanData';
        repositories.Peter_ViktorsData = 'J:\ViktorsData';
        repositories.Peter_OmidsData = 'J:\OmidsData';
        repositories.NYUshare_Viktor = 'Z:\Homes\vargav01\Analysis';
        repositories.NYUshare_Peter_AmplipexData = 'Z:\Homes\peterp03\DataBank\AmplipexData';
        repositories.NYUshare_Misi = 'Z:\Homes\voerom01\RF';
        repositories.NYUshare_Misi2 = 'Z:\Homes\voerom01\UM\Kyounghwan\Passive_probe';
        repositories.NYUshare_Manu = 'Z:\Homes\valerm05';
        repositories.ManuPC = 'Z:\Homes\valerm05';
        repositories.AxoaxonicLabshare = 'Z:\Buzsakilabspace\LabShare\EnglishD\AxoAxo';
        repositories.NYUshare_PiriformCorticalRecordings = 'Z:\Buzsakilabspace\LabShare\PeterPetersen\PiriformCorticalRecordings';
        repositories.NYUshare_NickSteinmetz = 'Z:\Homes\peterp03\DataFromOthers\NickSteinmetz';
        repositories.NYUshare_AllenInstitute = 'Z:\Buzsakilabspace\Datasets\SiegleJ';
        repositories.NYUshare_Roman_e14 = 'Z:\Buzsakilabspace\LabShare\RomanHuszar\DATA\e14';
        repositories.NYUshare_Roman_e15 = 'Z:\Buzsakilabspace\LabShare\RomanHuszar\DATA\e15';
    case {'peters-imac.lan'}
        repositories.NYUshare_Datasets = '/Volumes/Peter_SSD_4';
        repositories.NYUshare_Peter = '/Volumes/Peter_SSD_4';
    otherwise
        warning([hostName, ' detected. No local paths found...'])
end