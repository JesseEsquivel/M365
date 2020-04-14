###############################################################################################################################################################################
#
# Microsoft Premier Field Engineering
# -Function to add DoD Roots and Intermediates (exported from installroot) to AzureAD Tenant for Legacy Certificate Based authN
# -01/29/2020
# -jesse.esquivel@microsoft.com
#
# Microsoft Disclaimer for custom scripts
# ========================================
# The sample scripts are not supported under any Microsoft standard support program or service. The sample scripts are provided AS IS without warranty of any kind. 
# Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 
# The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event shall Microsoft, its authors, or anyone
# else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of
# business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts
# or documentation, even if Microsoft has been advised of the possibility of such damages.
# ========================================
#
###############################################################################################################################################################################

$scriptpath = $MyInvocation.MyCommand.Path

#Couple examples, connect to AzureAD module, not MSOL. One note AuthorityType=1 vs AuthorityType=0 means intermediate or root. 0=Root 1=intermediate, 
#Connect-AzureAD -AzureEnvironmentName AzureUSGovernment

function add-DoDCertificate($DoDcert, $cdp, $type)
{
    $dir = Split-Path $scriptpath
    $file = Get-ChildItem "$dir\$DoDCert"
    $certname = $dir + "\" + $file.name
   
    $cert = Get-Content -Encoding byte $certname
    $new_ca = New-Object -TypeName Microsoft.Open.AzureAD.Model.CertificateAuthorityInformation
    $new_ca.AuthorityType = $type
    $new_ca.TrustedCertificate = $cert
    $new_ca.crlDistributionPoint = $cdp
    New-AzureADTrustedCertificateAuthority -CertificateAuthorityInformation $new_ca
}

#add DoD Roots to tenant
add-DoDCertificate "DoD_Root_CA_2__0x05__DoD_Root_CA_2.cer" "http://crl.disa.mil/getcrl?DoD%20Root%20CA%202" "0"
add-DoDCertificate "DoD_Root_CA_3__0x01__DoD_Root_CA_3.cer" "http://crl.disa.mil/getcrl?DoD%20Root%20CA%203" "0"
add-DoDCertificate "DoD_Root_CA_4__0x01__DoD_Root_CA_4.cer" "http://crl.disa.mil/getcrl?DoD%20Root%20CA%204" "0"
add-DoDCertificate "DoD_Root_CA_5__0x0F__DoD_Root_CA_5.cer" "http://crl.disa.mil/getcrl?DoD%20Root%20CA%205" "0"

#add DoD intermediates to tenant
#EMAIL CAs
add-DoDCertificate "DoD_Root_CA_2__0x079D__DOD_EMAIL_CA-33.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-33" "1"
add-DoDCertificate "DoD_Root_CA_2__0x07A0__DOD_EMAIL_CA-34.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-34" "1"
add-DoDCertificate "DoD_Root_CA_2__0x07C1__DOD_EMAIL_CA-39.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-39" "1"
add-DoDCertificate "DoD_Root_CA_2__0x07C2__DOD_EMAIL_CA-40.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-40" "1"
add-DoDCertificate "DoD_Root_CA_3__0x14__DOD_EMAIL_CA-41.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-41" "1"
add-DoDCertificate "DoD_Root_CA_3__0x15__DOD_EMAIL_CA-42.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-42" "1"
add-DoDCertificate "DoD_Root_CA_3__0x16__DOD_EMAIL_CA-43.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-43" "1"
add-DoDCertificate "DoD_Root_CA_3__0x17__DOD_EMAIL_CA-44.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-44" "1"
add-DoDCertificate "DoD_Root_CA_3__0x0123__DOD_EMAIL_CA-49.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-49" "1"
add-DoDCertificate "DoD_Root_CA_3__0x0124__DOD_EMAIL_CA-50.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-50" "1"
add-DoDCertificate "DoD_Root_CA_3__0x0125__DOD_EMAIL_CA-51.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-51" "1"
add-DoDCertificate "DoD_Root_CA_3__0x0126__DOD_EMAIL_CA-52.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-52" "1"
add-DoDCertificate "DoD_Root_CA_3__0x0304__DOD_EMAIL_CA-59.cer" "http://crl.disa.mil//getcrl?DOD%20EMAIL%20CA-59" "1"

#ID CAs
add-DoDCertificate "DoD_Root_CA_2__0x079C__DOD_ID_CA-33.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-33" "1"
add-DoDCertificate "DoD_Root_CA_2__0x079F__DOD_ID_CA-34.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-34" "1"
add-DoDCertificate "DoD_Root_CA_2__0x07C3__DOD_ID_CA-39.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-39" "1"
add-DoDCertificate "DoD_Root_CA_2__0x07C4__DOD_ID_CA-40.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-40" "1"
add-DoDCertificate "DoD_Root_CA_3__0x18__DOD_ID_CA-41.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-41" "1"
add-DoDCertificate "DoD_Root_CA_3__0x19__DOD_ID_CA-42.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-42" "1"
add-DoDCertificate "DoD_Root_CA_3__0x1A__DOD_ID_CA-43.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-43" "1"
add-DoDCertificate "DoD_Root_CA_3__0x1B__DOD_ID_CA-44.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-44" "1"
add-DoDCertificate "DoD_Root_CA_3__0x0127__DOD_ID_CA-49.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-49" "1"
add-DoDCertificate "DoD_Root_CA_3__0x0128__DOD_ID_CA-50.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-50" "1"
add-DoDCertificate "DoD_Root_CA_3__0x0129__DOD_ID_CA-51.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-51" "1"
add-DoDCertificate "DoD_Root_CA_3__0x012A__DOD_ID_CA-52.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-52" "1"
add-DoDCertificate "DoD_Root_CA_3__0x0305__DOD_ID_CA-59.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20CA-59" "1"

#ID SW CAs
add-DoDCertificate "DoD_Root_CA_2__0x079E__DOD_ID_SW_CA-35.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20SW%20CA-35" "1"
add-DoDCertificate "DoD_Root_CA_2__0x07A1__DOD_ID_SW_CA-36.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20SW%20CA-36" "1"
add-DoDCertificate "DoD_Root_CA_3__0x12__DOD_ID_SW_CA-37.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20SW%20CA-37" "1"
add-DoDCertificate "DoD_Root_CA_3__0x13__DOD_ID_SW_CA-38.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20SW%20CA-38" "1"
add-DoDCertificate "DoD_Root_CA_3__0x63__DOD_ID_SW_CA-45.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20SW%20CA-45" "1"
add-DoDCertificate "DoD_Root_CA_3__0x64__DOD_ID_SW_CA-46.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20SW%20CA-46" "1"
add-DoDCertificate "DoD_Root_CA_4__0x09__DOD_ID_SW_CA-47.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20SW%20CA-47" "1"
add-DoDCertificate "DoD_Root_CA_4__0x0A__DOD_ID_SW_CA-48.cer" "http://crl.disa.mil//getcrl?DOD%20ID%20SW%20CA-48" "1"
 
#SW CAs
add-DoDCertificate "DoD_Root_CA_3__0x012B__DOD_SW_CA-53.cer" "http://crl.disa.mil//getcrl?DOD%20SW%20CA-53" "1"
add-DoDCertificate "DoD_Root_CA_3__0x012C__DOD_SW_CA-54.cer" "http://crl.disa.mil//getcrl?DOD%20SW%20CA-54" "1"
add-DoDCertificate "DoD_Root_CA_4__0x48__DOD_SW_CA-55.cer" "http://crl.disa.mil//getcrl?DOD%20SW%20CA-55" "1"
add-DoDCertificate "DoD_Root_CA_4__0x49__DOD_SW_CA-56.cer" "http://crl.disa.mil//getcrl?DOD%20SW%20CA-56" "1"
add-DoDCertificate "DoD_Root_CA_5__0x10__DOD_SW_CA-57.cer" "http://crl.disa.mil//getcrl?DOD%20SW%20CA-57" "1"
add-DoDCertificate "DoD_Root_CA_5__0x09__DOD_SW_CA-58.cer" "http://crl.disa.mil//getcrl?DOD%20SW%20CA-58" "1"
add-DoDCertificate "DoD_Root_CA_3__0x0303__DOD_SW_CA-60.cer" "http://crl.disa.mil//getcrl?DOD%20SW%20CA-60" "1"
add-DoDCertificate "DoD_Root_CA_5__0x00C2__DOD_SW_CA-61.cer" "http://crl.disa.mil//getcrl?DOD%20SW%20CA-61" "1"

#Profit and enjoy :)
