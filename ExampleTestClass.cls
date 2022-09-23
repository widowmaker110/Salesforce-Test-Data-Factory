/**
 * ExampleTestClass
 * 
 * Proof that the Utility test data factory is working
 */
@isTest
public with sharing class ExampleTestClass {

    static testMethod void validateAccountCreated() {
        Account tempAccount = Utility_TestDataFactory.createAccount(null, true);
    }

    static testMethod void validateLeadCreated() {
        Lead tempLead = Utility_TestDataFactory.createLead(null, null, true);
    }

    static testMethod void validateCampaignCreated() {
        Campaign tempCampaign = Utility_TestDataFactory.createCampaign(null, true);
    }

    static testMethod void validateCampaignMemberCreated() {
        CampaignMember tempMember = Utility_TestDataFactory.createCampaignMember(null, null, null, true);
    }

    static testMethod void validateContactCreated() {
        Contact tempContact = Utility_TestDataFactory.createContact(null, null, true);
    }

    static testMethod void validateCaseCreated() {
        Case tempCase = Utility_TestDataFactory.createCase(true);
    }

    static testMethod void validateOpportunityCreated() {
        Opportunity tempOpp = Utility_TestDataFactory.createOpportunity(null, null, null, null, null, true);
    }

    static testMethod void validateProductCreated() {
        Product2 tempProd = Utility_TestDataFactory.createProduct(null, true);
    }

    static testMethod void validateOppLineItemCreated() {
        OpportunityLineItem tempOppLine = Utility_TestDataFactory.createOpportunityLineItem(null, null, null, null, null, true);
    }

    static testMethod void validatePricebookCreated() {
        Pricebook2 tempPricebook = Utility_TestDataFactory.createPricebook(null, true);
    }

    static testMethod void validatePricebookEntryCreated() {
        PricebookEntry tempPricebookentry = Utility_TestDataFactory.createPricebookEntry(null, null, null, true);
    }

    static testMethod void validateBaseUserCreated() {
        User tempuser = Utility_TestDataFactory.createBaseUser(null, null, null, null, null, null, null, null, Utility_TestDataFactory.getProfileByName('Standard User').Id, null, null, null, null, true);
    }

    static testMethod void validateAdminUserCreated() {
        User tempuser = Utility_TestDataFactory.createSystemAdmin(null, null, null, null, null, null, null, null, null, null, null, null, true);
    }
}