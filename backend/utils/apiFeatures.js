class ApiFeatures {
    constructor(query, queryStr) {
        this.query = query;
        this.queryStr = queryStr;
    }
    search() {
        const keyword = this.queryStr.keyword
            ?
            {
                $or: [
                    {
                        name: {
                            $regex: this.queryStr.keyword,
                            $options: "i",
                        }
                    },
                    {
                        rollno: {
                            $regex: this.queryStr.keyword,
                            $options: "i",
                        }
                    }
                ]
            }
            : {};

        this.query = this.query.find({ ...keyword });
        return this;
    }
    pagination(resultPerPage) {
        const currentPage = Number(this.queryStr.page) || 1;
        const skip = resultPerPage * (currentPage - 1);
        this.query = this.query.limit(resultPerPage).skip(skip);
        return this;
    }
}
export default ApiFeatures;