public with sharing class OrgSegmentService {
    public static final String SEGMENT_STARTUP = 'Startup';
    public static final String SEGMENT_MID_CAP = 'Mid Cap';
    public static final String SEGMENT_ENTERPRISE = 'Enterprise';

    public static final Decimal THRESHOLD_ENTERPRISE = 100000000;
    public static final Decimal THRESHOLD_MID_CAP = 1000000;

    /**
     * Calculates and returns the Org Segment for a given Annual Revenue value.
     * Rules:
     * - 100,000,000 or more: Enterprise
     * - 1,000,000 to under 100,000,000: Mid Cap
     * - Under 1,000,000, or blank (null): Startup
     *
     * @param annualRevenue The annual revenue amount to evaluate.
     * @return The organization segment: 'Enterprise', 'Mid Cap', or 'Startup'.
     */
    public static String calculateSegment(Decimal annualRevenue) {
        if (annualRevenue == null || annualRevenue < THRESHOLD_MID_CAP) {
            return SEGMENT_STARTUP;
        } else if (annualRevenue >= THRESHOLD_ENTERPRISE) {
            return SEGMENT_ENTERPRISE;
        } else {
            return SEGMENT_MID_CAP;
        }
    }

    /**
     * Alias for calculateSegment(Decimal annualRevenue).
     */
    public static String getSegment(Decimal annualRevenue) {
        return calculateSegment(annualRevenue);
    }

    /**
     * Classifies a list of Account records in memory by calculating each account's
     * Org Segment from its AnnualRevenue and setting the Org_Segment__c field.
     *
     * @param accounts List of Account records to classify in memory.
     * @return The updated list of Account records.
     */
    public static List<Account> classify(List<Account> accounts) {
        if (accounts == null) {
            return null;
        }
        for (Account acc : accounts) {
            acc.Org_Segment__c = calculateSegment(acc.AnnualRevenue);
        }
        return accounts;
    }

    /**
     * Alias for classify(List<Account> accounts).
     */
    public static List<Account> classifyAccounts(List<Account> accounts) {
        return classify(accounts);
    }

    /**
     * Exposes segment calculation for a list of accounts.
     */
    public static List<Account> calculateSegment(List<Account> accounts) {
        return classify(accounts);
    }

    /**
     * Alias for calculateSegment(List<Account> accounts).
     */
    public static List<Account> calculateSegments(List<Account> accounts) {
        return classify(accounts);
    }

    /**
     * Sets Org_Segment__c on a list of accounts in memory.
     */
    public static List<Account> setOrgSegment(List<Account> accounts) {
        return classify(accounts);
    }
}

