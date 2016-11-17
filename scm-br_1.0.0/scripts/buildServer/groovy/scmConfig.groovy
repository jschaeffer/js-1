jenkins {
    user="jenkinsAdmin"
    password="@dm1n"
    baseURL="http://cvbuild.cv.infra/:7001"
    jobURL=baseURL+"/view/All"
}

jira {
    user="cvbuild"
    password="pa\$\$w0rd"
    baseURL="https://cvjira.atlassian.net/"
    issueURI="rest/api/latest/issue/"
    cliScriptDir="/opt/tools/atlassian-cli"
    cliScriptName="jira.sh"
}

'crypt' {
    view="All"
    prefix="crypt"
}

'common-lib' {
    view="All"
    prefix="common-lib"
}

'caas-core' {
    view="All"
    prefix="caas-core"
}

'dmp-config' {
    view="All"
    prefix="dmp-config"
}

'smsi-msp-relay' {
    view="All"
    prefix="smsi-msp-relay"
}

'smsiCorrection' {
    view="All"
    prefix="smsiCorrection"
}

'POIS' {
    view="All"
    prefix="POIS"
}

'ad-load-manager' {
    view="All"
    prefix="ad-load-manager"
}

'SDC-session-collector' {
    view="All"
    prefix="SDC-session-collector"
}

'request-mgr' {
    view="All"
    prefix="request-mgr"
}

'ads-core' {
    view="All"
    prefix="ads-core"
}

'Dynamic-Ad-Insertion-cm' {
    view="All"
    prefix="DAI-CampaignMgmt"
}

'int-test-support' {
    view="All"
    prefix="int-test-support"
}

'impression_collector' {
    view="All"
    prefix="impression_collector"
}

'Dynamic-Ad-Insertion-engine' {
    view="All"
    prefix="DAI-DecisionEngine"
}

'dai-metadata-ingestion' {
    view="All"
    prefix="dai-metadata-ingestion"
}

'Pgmr-Cpgn-Int' {
    view="All"
    prefix="Pgmr-Cpgn-Int"
}

'ADI-MDI' {
    view="All"
    prefix="ADI-MDI"
}

'metadata-publisher' {
    view="All"
    prefix="metadata-publisher"
}

'MicroDev' {
    view="All"
    prefix="MicroDev"
}

'dai-smsi-relay' {
    view="All"
    prefix="dai-smsi-relay"
}

'acp' {
    view="All"
    prefix="acp"
}

'Sheringham' {
    view="All"
    prefix="Sheringham"
}

'dai-dce' {
    view="All"
    prefix="dai-dce"
}

'dai_scm' {
    view="All"
    prefix="dai_scm"
}

'test_proj' {
    view="All"
    prefix="test_proj"
}

'dai-cip' {
    view="All"
    prefix="dai-cip"
}

'dai-cip-feedback' {
    view="All"
    prefix="dai-cip-feedback"
}

'dai-etl-feeder' {
    view="All"
    prefix="dai-etl"
}

'dai-lincoln' {
    view="All"
    prefix="dai-lincoln"
}

'dai-smsi' {
    view="All"
    prefix="dai-smsi"
}

'smsi-publisher' {
    view="All"
    prefix="smsi-publisher"
}

'dai-national-cis' {
    view="All"
    prefix="dai-national-cis"
}

'ops-dce-metadata-agent' {
    view="All"
    prefix="ops-dce-metadata-agent"
}

