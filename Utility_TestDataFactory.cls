/**
 * Utility_TestDataFactory
 * 
 * (c) 2022 Widowmaker110
 * This code is licensed under MIT license (see LICENSE.txt for details)
 * 
 * General utility class which allows for parallel test execution.
 * An opinionated design pattern to reduce DML usage across test 
 * methods, allow function overloading, and maintain simplicity.
 * 
 * Designed for Salesforce standard objects as a model but can
 * be extended for personal/commercial use.
 */
@isTest
public with sharing class Utility_TestDataFactory {

    public static Account createAccount(String name, Boolean doInsert) 
    {
        if(name == null)
        {
            name = randomString(10);
        }

        Account acc = new Account(name=name);
		
        if(doInsert) 
        {
			insert acc;
		}

		return acc;
	}

    public static Lead createLead(String company, String lastName, Boolean doInsert)
    {
        if(company == null)
        {
            company = randomString(20);
        }

        if(lastName == null)
        {
            lastName = randomString(20);
        }

        Lead tempLead = new Lead();

        tempLead.Company = company;
        tempLead.LastName = lastName;

        if(doInsert)
        {
            insert tempLead;
        }

        return tempLead;
    }

    public static Campaign createCampaign(String name, Boolean doInsert)
    {
        if(name == null)
        {
            name = randomString(20);
        }

        Campaign tempCampaign = new Campaign();

        tempCampaign.Name = name;

        if(doInsert)
        {
            insert tempCampaign;
        }

        return tempCampaign;
    }

    public static CampaignMember createCampaignMember(Id campaignId, Id leadId, Id contactId, Boolean doInsert)
    {
        if(campaignId == null)
        {
            campaignId = createCampaign(null, true).Id;
        }

        if(leadId == null && contactId == null)
        {
            leadId = createLead(null, null, true).Id;
        }

        CampaignMember campMember = new CampaignMember();

        if(leadId != null)
        {
            campMember.LeadId = leadId;
        }
        else
        {
            campMember.ContactId = contactId;
        }

        campMember.CampaignId = campaignId;

        if(doInsert)
        {
            insert campMember;
        }

        return campMember;
    }
	
	public static Contact createContact(Id accountId, String lastName, Boolean doInsert) 
    {   
        if(accountId == null)
        {
            accountId = createAccount(null, true).Id;
        }

        if(lastName == null)
        {
            lastName = randomString(10);
        }

        Contact c = new Contact(lastName=lastName, accountId=accountId);
		
        if(doInsert) 
        {
			insert c;
		}

		return c;
	}

    public static Case createCase(Boolean doInsert)
    {
        Case tempCase = new Case();

        if(doInsert)
        {
            insert tempCase;
        }

        return tempCase;
    }

	public static Opportunity createOpportunity(Id accountId, String name, Date closedDate, String stageName, Decimal amount, Boolean doInsert) 
    {	
        if(accountId == null)
        {
            accountId = createAccount(null, true).Id;
        }

        if(closedDate == null)
        {
            closedDate = System.Today();
        }

        if(stageName == null)
        {
            stageName = 'Prospecting';
        }

        if(name == null)
        {
            name = randomString(10);
        }

        Opportunity opp = new Opportunity();
        opp.name = name;
        opp.accountId = accountid;
        opp.amount = amount;
        opp.closeDate = closedDate;
        opp.stageName = stageName;

        if(doInsert)
        {
            insert opp;
        }

		return opp;
	}

    public static Product2 createProduct(String name, Boolean doInsert)
    {
        if(name == null)
        {
            name = randomString(10);
        }

        Product2 prod = new Product2();
        prod.Name = name;
        
        if(doInsert)
        {
            insert prod;
        }
        
        return prod;
    }

    public static OpportunityLineItem createOpportunityLineItem(Id opportunityId, Id pricebookEntryId, Decimal totalPrice, Decimal unitPrice, Integer quantity, Boolean doInsert)
    {
        if(opportunityId == null)
        {
            opportunityId = createOpportunity(null, null, null, null, null, true).Id;
        }

        if(pricebookEntryId == null)
        {
            pricebookEntryId = createPricebookEntry(null, null, null, true).Id;
        }

        if(totalPrice == null && unitPrice == null)
        {
            unitPrice = randomDecimal(3);
        }

        if(quantity == null)
        {
            quantity = randomInteger(2);
        }

        OpportunityLineItem oppLine = new OpportunityLineItem();

        oppLine.OpportunityId = opportunityId;
        oppLine.PricebookEntryId = pricebookEntryId;
        oppLine.UnitPrice = unitPrice;
        oppLine.Quantity = quantity;

        if(doInsert)
        {
            insert oppLine;
        }

        return oppLine;
    }

    public static Pricebook2 createPricebook(String name, Boolean doInsert)
    {
        if(name == null)
        {
            name = randomString(10);
        }

        Pricebook2 pricebook = new Pricebook2();
        pricebook.Name = name;
        pricebook.isActive = true;

        if(doInsert)
        {
            insert pricebook;
        }
        
        return pricebook;
    }

    public static PricebookEntry createPricebookEntry(Id pricebookId, Id productId, Decimal unitPrice, Boolean doInsert)
    {
        if(pricebookId == null)
        {
            pricebookId = createPricebook(null, true).Id;
        }

        if(productId == null)
        {
            productId = createProduct(null, true).Id;
        }

        if(unitPrice == null)
        {
            unitPrice = randomDecimal(4);
        }

        PricebookEntry entry = new PricebookEntry();
        entry.Pricebook2Id = pricebookId;
        entry.Product2Id = productId;
        entry.UnitPrice = unitPrice;
        entry.IsActive = true;

        if(doInsert)
        {   
            try{
                insert entry;
            }catch(System.DmlException e)
            {
                // Standard Pricebook probably doesn't exist, use the test's
                entry.Pricebook2Id = Test.getStandardPricebookId();

                insert entry;
            }
        }

        return entry;
    }

    // =========
    // Users
    // =========

    public static Profile getProfileByName(String name)
    {
        if(name == null)
        {
            throw new Utility_TestDataFactoryException('Name is required to get a profile');
        }

        return [SELECT Id FROM Profile WHERE Name = :name LIMIT 1];
    }

    public static User createBaseUser(String alias, String defualtGroupNotifFrequency, String digestFrequency, String email, String emailEncodingKey, 
                                    String lastName, String languageLocalKey, String localeSidKey, Id profileId, String timeZoneSidKey, String username, 
                                    Boolean marketingUser, Boolean offlineUser, Boolean doInsert)
    {
        if(profileId == null)
        {
            throw new Utility_TestDataFactoryException('Profile ID is required to create a user');
        }

        if(alias == null)
        {
            alias = randomString(8);
        }

        if(defualtGroupNotifFrequency == null)
        {
            defualtGroupNotifFrequency = 'N';
        }

        if(digestFrequency == null)
        {
            digestFrequency = 'N';
        }

        if(email == null)
        {
            email = randomEmail(null, null);
        }

        if(emailEncodingKey == null)
        {
            emailEncodingKey = 'UTF-8';
        }

        if(lastName == null)
        {
            lastName = randomString(12);
        }

        if(languageLocalKey == null)
        {
            languageLocalKey = 'en_US';
        }

        if(localeSidKey == null)
        {
            localeSidKey = 'en_US';
        }

        if(timeZoneSidKey == null)
        {
            timeZoneSidKey = 'America/Los_Angeles';
        }

        if(username == null)
        {
            username = randomEmail(null, null);
        }

        if(marketingUser == null)
        {
            marketingUser = false;
        }

        if(offlineUser == null)
        {
            offlineUser = false;
        }

        User baseUser = new User();

        baseUser.Alias = alias;
        baseUser.DefaultGroupNotificationFrequency = defualtGroupNotifFrequency;
        baseUser.DigestFrequency = digestFrequency;
        baseUser.Email = email;
        baseUser.EmailEncodingKey = emailEncodingKey;
        baseUser.LastName = lastName;
        baseUser.LanguageLocaleKey = languageLocalKey;
        baseUser.LocaleSidKey = localeSidKey;
        baseUser.ProfileId = profileId;
        baseUser.TimeZoneSidKey = timeZoneSidKey;
        baseUser.Username = username;
        baseUser.UserPermissionsMarketingUser = marketingUser;
        baseUser.UserPermissionsOfflineUser = offlineUser;

        if(doInsert)
        {
            insert baseUser;
        }

        return baseUser;
    }

    public static User createSystemAdmin(String alias, String defualtGroupNotifFrequency, String digestFrequency, String email, String emailEncodingKey, 
                                    String lastName, String languageLocalKey, String localeSidKey, String timeZoneSidKey, String username, 
                                    Boolean marketingUser, Boolean offlineUser, Boolean doInsert)
    {
        Profile sysAdminProfile = getProfileByName('System Administrator');

        return createBaseUser(alias, defualtGroupNotifFrequency, digestFrequency, email, emailEncodingKey, lastName, languageLocalKey, localeSidKey, 
                            sysAdminProfile.Id, timeZoneSidKey, username, marketingUser, offlineUser, doInsert);
    }

    // =========
    // UTILITY FUNCTIONS
    // =========

    public static String randomString(Integer stringLength)
    {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';

        while (randStr.length() < stringLength) 
        {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }

        return randStr;
    }

    public static String randomEmail(Integer prefixLength, String domain)
    {
        if(domain == null)
        {
            domain = 'gmail.com';
        }

        if(prefixLength == null)
        {
            prefixLength = 15;
        }

        return randomString(prefixLength) + '@' + domain;
    }

    public static Integer randomInteger(Integer numberLength)
    {
        final String chars = '1234567890';
        String randStr = '';

        while (randStr.length() < numberLength) 
        {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }

        return Integer.valueOf(randStr);
    }

    public static Decimal randomDecimal(Integer numberLength)
    {
        return Decimal.valueOf(randomInteger(numberLength));
    }

    public class Utility_TestDataFactoryException extends Exception {}
}