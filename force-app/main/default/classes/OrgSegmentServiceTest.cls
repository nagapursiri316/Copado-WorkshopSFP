@IsTest
private class OrgSegmentServiceTest {
    @IsTest
    static void testEnterpriseBoundary100M() {
        Test.startTest();
        String segmentExact = OrgSegmentService.calculateSegment(100000000);
        String segmentAbove = OrgSegmentService.calculateSegment(100000001);
        String segmentLarge = OrgSegmentService.calculateSegment(500000000);
        Test.stopTest();

        System.assertEquals(OrgSegmentService.SEGMENT_ENTERPRISE, segmentExact, '100,000,000 must be Enterprise');
        System.assertEquals(OrgSegmentService.SEGMENT_ENTERPRISE, segmentAbove, '100,000,001 must be Enterprise');
        System.assertEquals(OrgSegmentService.SEGMENT_ENTERPRISE, segmentLarge, '500,000,000 must be Enterprise');
    }

    @IsTest
    static void testMidCapBoundaries() {
        Test.startTest();
        String segmentUpperBoundary = OrgSegmentService.calculateSegment(99999999);
        String segmentLowerBoundary = OrgSegmentService.calculateSegment(1000000);
        String segmentMiddle = OrgSegmentService.calculateSegment(50000000);
        Test.stopTest();

        System.assertEquals(OrgSegmentService.SEGMENT_MID_CAP, segmentUpperBoundary, '99,999,999 must be Mid Cap');
        System.assertEquals(OrgSegmentService.SEGMENT_MID_CAP, segmentLowerBoundary, '1,000,000 must be Mid Cap');
        System.assertEquals(OrgSegmentService.SEGMENT_MID_CAP, segmentMiddle, '50,000,000 must be Mid Cap');
    }

    @IsTest
    static void testStartupBoundaries() {
        Test.startTest();
        String segmentUpperBoundary = OrgSegmentService.calculateSegment(999999);
        String segmentNull = OrgSegmentService.calculateSegment(null);
        String segmentZero = OrgSegmentService.calculateSegment(0);
        String segmentNegative = OrgSegmentService.calculateSegment(-100);
        Test.stopTest();

        System.assertEquals(OrgSegmentService.SEGMENT_STARTUP, segmentUpperBoundary, '999,999 must be Startup');
        System.assertEquals(OrgSegmentService.SEGMENT_STARTUP, segmentNull, 'null must be Startup');
        System.assertEquals(OrgSegmentService.SEGMENT_STARTUP, segmentZero, '0 must be Startup');
        System.assertEquals(OrgSegmentService.SEGMENT_STARTUP, segmentNegative, 'negative revenue must be Startup');
    }

    @IsTest
    static void testClassifyAccountListInMemory() {
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Acc Enterprise', AnnualRevenue = 100000000),
            new Account(Name = 'Acc MidCap High', AnnualRevenue = 99999999),
            new Account(Name = 'Acc MidCap Low', AnnualRevenue = 1000000),
            new Account(Name = 'Acc Startup High', AnnualRevenue = 999999),
            new Account(Name = 'Acc Blank Revenue', AnnualRevenue = null),
            new Account(Name = 'Acc Zero Revenue', AnnualRevenue = 0)
        };

        Test.startTest();
        List<Account> classified = OrgSegmentService.classify(testAccounts);
        Test.stopTest();

        System.assertNotEquals(null, classified, 'Classified list should not be null');
        System.assertEquals(6, testAccounts.size(), 'List size should remain unchanged');
        System.assertEquals(OrgSegmentService.SEGMENT_ENTERPRISE, testAccounts[0].Org_Segment__c, 'Account with 100M should be Enterprise');
        System.assertEquals(OrgSegmentService.SEGMENT_MID_CAP, testAccounts[1].Org_Segment__c, 'Account with 99,999,999 should be Mid Cap');
        System.assertEquals(OrgSegmentService.SEGMENT_MID_CAP, testAccounts[2].Org_Segment__c, 'Account with 1M should be Mid Cap');
        System.assertEquals(OrgSegmentService.SEGMENT_STARTUP, testAccounts[3].Org_Segment__c, 'Account with 999,999 should be Startup');
        System.assertEquals(OrgSegmentService.SEGMENT_STARTUP, testAccounts[4].Org_Segment__c, 'Account with null revenue should be Startup');
        System.assertEquals(OrgSegmentService.SEGMENT_STARTUP, testAccounts[5].Org_Segment__c, 'Account with 0 revenue should be Startup');
    }

    @IsTest
    static void testAliasesAndEdgeCases() {
        Test.startTest();
        System.assertEquals(OrgSegmentService.SEGMENT_ENTERPRISE, OrgSegmentService.getSegment(100000000));
        System.assertEquals(null, OrgSegmentService.classify(null));

        List<Account> emptyList = new List<Account>();
        OrgSegmentService.classifyAccounts(emptyList);
        System.assertEquals(0, emptyList.size());

        List<Account> accountsForOverloads = new List<Account>{
            new Account(Name = 'Overload Test', AnnualRevenue = 2000000)
        };
        OrgSegmentService.calculateSegment(accountsForOverloads);
        System.assertEquals(OrgSegmentService.SEGMENT_MID_CAP, accountsForOverloads[0].Org_Segment__c);

        OrgSegmentService.calculateSegments(accountsForOverloads);
        System.assertEquals(OrgSegmentService.SEGMENT_MID_CAP, accountsForOverloads[0].Org_Segment__c);

        OrgSegmentService.setOrgSegment(accountsForOverloads);
        System.assertEquals(OrgSegmentService.SEGMENT_MID_CAP, accountsForOverloads[0].Org_Segment__c);
        Test.stopTest();
    }
}

