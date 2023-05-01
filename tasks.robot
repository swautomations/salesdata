*** Settings ***
Documentation       Insert the sales data for the week and export it as a PDF.

Library             RPA.Browser.Selenium    auto_close=${False}
Library             RPA.Excel.Files
Library             RPA.HTTP
Library             RPA.PDF


*** Tasks ***
Insert the sales data for the week and export it as a PDF
    Open the intranet website
    Log in to intranet
    Download the Excel file
    Fill the form from excel file
    Collect the results
    Export the table as a PDF
    [Teardown]    Log out and close the browser


*** Keywords ***
Open the intranet website
    Open Available Browser    https://robotsparebinindustries.com/

Log in to intranet
    Input Text    username    maria
    Input Password    password    thoushallnotpass
    Submit Form
    Wait Until Element Is Visible    id:sales-form

Download the Excel file
    Download    https://robotsparebinindustries.com/SalesData.xlsx    overwrite=True

Fill and submit sales data
    [Arguments]    ${sales_rep}
    Input Text    firstname    ${sales_rep}[First Name]
    Input Text    lastname    ${sales_rep}[Last Name]
    Input Text    salesresult    ${sales_rep}[Sales]
    Select From List By Value    salestarget    ${sales_rep}[Sales Target]
    Click Button    Submit

Fill the form from excel file
    Open Workbook    SalesData.xlsx
    ${sales_reps}=    Read Worksheet As Table    header=True
    Close Workbook
    FOR    ${sales_rep}    IN    @{sales_reps}
        Log    ${sales_rep}
        Fill and submit sales data    ${sales_rep}
    END

Collect the results
    Screenshot    css:div.sales-summary    ${OUTPUT_DIR}${/}sales_summary.png

Export the table as a PDF
    Wait Until Element Is Visible    id:sales-results
    ${sales_results_html}=    Get Element Attribute    id:sales-results    outerHTML
    Html To Pdf    ${sales_results_html}    ${OUTPUT_DIR}${/}sales_result.pdf

Log out and close the browser
    Click Button    Log out
    Close Browser
